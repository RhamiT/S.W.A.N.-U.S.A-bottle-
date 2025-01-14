#include <iostream>
#include <unordered_map>
#include <string>
#include <vector>

using namespace std;
class fileCreator
{
private:
    vector<string> keys;
    unordered_map<string, string> bvg;    // contains json object for bvg
    unordered_map<string, string> bottle; // contains json object for bottle status

public:
    // functions
    void entry(string, string);
    void entry(string, int);
    void entry(string, double);
    string genJson(string, string);
};