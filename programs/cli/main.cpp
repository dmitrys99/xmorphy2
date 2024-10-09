#include <chrono>
#include <filesystem>
#include <iostream>
#include <iterator>
#include <memory>
#include <sstream>
#include <string>
#include <xmorphy/graphem/Tokenizer.h>
#include <xmorphy/graphem/SentenceSplitter.h>
#include <xmorphy/ml/Disambiguator.h>
#include <xmorphy/ml/TFJoinedModel.h>
#include <xmorphy/ml/MorphemicSplitter.h>
#include <xmorphy/ml/SingleWordDisambiguate.h>
#include <xmorphy/morph/Processor.h>
#include <xmorphy/morph/WordFormPrinter.h>
#include <xmorphy/utils/UniString.h>
#include <xmorphy/morph/PrettyFormater.h>
#include <xmorphy/morph/TSVFormater.h>
#include <xmorphy/morph/JSONEachSentenceFormater.h>
#include <xmorphy/ml/TFDisambiguator.h>
#include <xmorphy/ml/TFMorphemicSplitter.h>
#include <boost/program_options.hpp>

#include "CivetServer.h"

using namespace X;
using namespace std;


class RootHandler : public CivetHandler
{
  public:
    bool handleGet(CivetServer *server, struct mg_connection *conn)
    {
        mg_printf(conn,
                  "HTTP/1.1 200 OK\r\nContent-Type: "
                  "text/html\r\nConnection: close\r\n\r\n");
        mg_printf(conn, "<html><body>\r\n");
        mg_printf(conn, "<h1>Hello</h1>\r\n");
        mg_printf(conn, "</body></html>\r\n");
        return true;
    }
};

struct Options
{
    std::string input_file;
    std::string output_file;
    bool disambiguate = false;
    bool context_disambiguate = false;
    bool morphemic_split = false;
    std::string format;
    int port = 8080;
    bool web_mode = false;
};

std::string processSentence(std::string& sentence, Options& opts, FormaterPtr& formatter) {
    Tokenizer tok;

    TFDisambiguator tf_disambig;
    TFMorphemicSplitter morphemic_splitter;
    Processor analyzer;
    SingleWordDisambiguate disamb;
    TFJoinedModel joiner;
    std::vector<TokenPtr> tokens = tok.analyze(UniString(sentence));
    std::vector<WordFormPtr> forms = analyzer.analyze(tokens);

    if (opts.disambiguate)
        disamb.disambiguate(forms);

    bool joined_model_failed = true;
    if (opts.morphemic_split && opts.context_disambiguate)
    {
        joined_model_failed = !joiner.disambiguateAndMorphemicSplit(forms);
    }

    if (joined_model_failed && (opts.morphemic_split || opts.context_disambiguate))
    {
        tf_disambig.disambiguate(forms);
    }

    if (opts.morphemic_split && (!opts.context_disambiguate || joined_model_failed))
    {
        for (auto & form : forms)
        {
            morphemic_splitter.split(form);
        }
    }

    return formatter->format(forms);
}

class WordsHandler : public CivetHandler
{
    private:
        FormaterPtr& formatter;
        Options& opts;
    public:
    WordsHandler(Options& o, FormaterPtr& f) : formatter(f), opts(o) { }

    bool handlePost(CivetServer *server, struct mg_connection *conn)
    {
        std::string s = "";
        mg_printf(conn,
                  "HTTP/1.1 200 OK\r\nContent-Type: "
                  "application/json\r\nConnection: close\r\n\r\n");
        if (CivetServer::getParam(conn, "param", s)) {
            std::string res = processSentence(s, opts, formatter);
            mg_printf(conn, "{\"answer\": %s}", res.c_str());
        } else {
            mg_printf(conn, "{\"answer\": \"None. Use 'param' POST parameter.\"}");
        }
        return true;
    }

};

namespace po = boost::program_options;
bool processCommandLineOptions(int argc, char ** argv, Options & opts)
{
    try
    {
        po::options_description desc("XMorphy morphological analyzer for Russian language.");
        desc.add_options()
            ("input,i", po::value<string>(&opts.input_file), "set input file")
            ("output,o", po::value<string>(&opts.output_file), "set output file")
            ("disambiguate,d", "disambiguate single word")
            ("context-disambiguate,c", "disambiguate with context")
            ("morphem-split,m", "split morphemes")
            ("format,f", po::value<string>(&opts.format), "format to use")
            ("web,w", "start web server")
            ("port,p", po::value<int>(&opts.port), "port to start web to");

        po::variables_map vm;
        po::store(po::parse_command_line(argc, argv, desc), vm);

        if (vm.count("help"))
        {
            std::cout << desc << "\n";
            return false;
        }

        po::notify(vm);
        if (vm.count("disambiguate"))
            opts.disambiguate = true;

        if (vm.count("context-disambiguate"))
            opts.context_disambiguate = true;

        if (vm.count("morphem-split"))
            opts.morphemic_split = true;

        if (vm.count("web"))
            opts.web_mode = true;
    }
    catch (const std::exception & ex)
    {
        std::cerr << "Error: " << ex.what() << "\n";
        return false;
    }
    catch (...)
    {
        std::cerr << "Unknown error!"
                  << "\n";
        return false;
    }
    return true;
}


void startWeb(Options& opts, FormaterPtr& formatter) {
    mg_init_library(0);

    const char *options[] = {
        "document_root", ".", "listening_ports", std::to_string(opts.port).c_str(), 0};

    std::vector<std::string> cpp_options;
//    for (int i=0; i<(sizeof(options)/sizeof(options[0])-1); i++) {
//        cpp_options.push_back(options[i]);
//    }

    // CivetServer server(options); // <-- C style start
    CivetServer server(cpp_options); // <-- C++ style start

    RootHandler h_root;
    server.addHandler("", h_root);

    WordsHandler h_words(opts, formatter);
    server.addHandler("/words", h_words);

    printf("Run server at http://localhost:%d\n", opts.port);

    while (true) {
        sleep(1);
    }

    printf("Bye!\n");
    mg_exit_library();
}

int main(int argc, char ** argv)
{
    Options opts;

    if (!processCommandLineOptions(argc, argv, opts))
        return 1;

    std::istream * is = &cin;
    std::ostream * os = &cout;
    if (!opts.input_file.empty())
    {
        is = new ifstream(opts.input_file);
    }
    if (!opts.output_file.empty())
    {
        os = new ofstream(opts.output_file);
    }
    SentenceSplitter ssplitter(*is);

    FormaterPtr formatter;

    if (opts.web_mode) {
        formatter = std::make_unique<JSONEachSentenceFormater>(opts.morphemic_split);
        startWeb(opts, formatter);
    } else {

        if (opts.format == "TSV")
            formatter = std::make_unique<TSVFormater>(opts.morphemic_split);
        else if (opts.format == "JSONEachSentence")
            formatter = std::make_unique<JSONEachSentenceFormater>(opts.morphemic_split);
        else
            formatter = std::make_unique<PrettyFormater>(opts.morphemic_split);
        do
        {
            std::string sentence;
            ssplitter.readSentence(sentence);
            if (sentence.empty())
                continue;

            (*os) << processSentence(sentence, opts, formatter) << std::endl;

            os->flush();
        } while(!ssplitter.eof());
    }
    return 0;
}
