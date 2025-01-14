/*
    key:
    ae = any entry (previous or current)
    "identifier" = any user defined name must be between ""
    "value" = any valid string must be between "", note: common string format is required
    number = any integer, double, float
    bool = true or false
    null = self explanitory

    Json format example:
    {
        "identifier" : "value",
        "identifier" : number,
        "identifier" : bool,
        "identifier" : null,
        "identifier" : {"identifier" : ae},
        "identifier" : [ae, ae, ae, ...., ae]
    }
*/
#include "communications.h"
#include <iostream>
#include <string>
#include <cstring>
#include <string_view>
#include <cstdint>
#include <vector>

// TODO - go back and implement defensive msr for err

void fileCreator::entry(string id, string value)
{
    uint8_t type = 0; // 0 == none, 1 == bvg, 2 == bottle
    // process data
    string processedId = dataProcessID(id);
    string processedVal = stringToLower(value);

    // determine where data needs to go
    if (processedId.find("bvg", 0, 3) != string::npos)
    {
        type = 1;
    }
    else if (processedId.find("btl", 0, 3) != string::npos)
    {
        type = 2;
    }
    else
    {
        cerr << "ERR: improper id passed." << endl;
        type = 0;
    }
    switch (type)
    {
    case 1:
        bvg[processedId] = processedVal;
        break;
    case 2:
        bottle[processedId] = processedVal;
        break;
    default:
        cerr << "ERR: no proper source type." << endl;
        break;
    };
}
void fileCreator::entry(string id, int value)
{
    uint8_t type = 0; // 0 == none, 1 == bvg, 2 == bottle
    // process data
    string processedId = dataProcessID(id);
    int processedVal = value;

    // determine where data needs to go
    if (processedId.find("bvg", 0, 3) != string::npos)
    {
        type = 1;
    }
    else if (processedId.find("btl", 0, 3) != string::npos)
    {
        type = 2;
    }
    else
    {
        cerr << "ERR: improper id passed." << endl;
        type = 0;
    }
    switch (type)
    {
    case 1:
        bvg[processedId] = to_string(processedVal);
        break;
    case 2:
        bottle[processedId] = to_string(processedVal);
        break;
    default:
        cerr << "ERR: no proper source type." << endl;
        break;
    };
}
void fileCreator::entry(string id, double value)
{
    uint8_t type = 0; // 0 == none, 1 == bvg, 2 == bottle
    // process data
    string processedId = dataProcessID(id);
    double processedVal = value;

    // determine where data needs to go
    if (processedId.find("bvg", 0, 3) != string::npos)
    {
        type = 1;
    }
    else if (processedId.find("btl", 0, 3) != string::npos)
    {
        type = 2;
    }
    else
    {
        cerr << "ERR: improper id passed." << endl;
        type = 0;
    }
    switch (type)
    {
    case 1:
        bvg[processedId] = to_string(processedVal);
        break;
    case 2:
        bottle[processedId] = to_string(processedVal);
        break;
    default:
        cerr << "ERR: no proper source type." << endl;
        break;
    };
}
string fileCreator::genJson(string id, string value)
{

    return "";
}
string genItems()
{
}
string dataProcessID(string id)
{
    /*
        "source_function"
        source = bvg, btl
        function = lvl,id || battery

        user must put in valid source entry w\out regarding capitalization (beverage,bvg || bottle,btl)
        user must put in valid function w\out regarding capitalization (level,lvl,id,identification || battery)
        these can be in any order:
            -source function,source-function,source_function,etc
            -function source,function-source,function_source,etc
        this function then takes this input and generates the above accepted output
    */
    string processedId = stringToLower(id);
    vector<string> sep = split(processedId);

    string part1 = "";
    string part2 = "";
    for (string s : sep)
    {
        if (s == "bvg" || s == "beverage")
        {
            if (part1 == "")
            {
                part1 = "bvg_";
            }
            else
            {
                cerr << "ERR: source type already defined try again";
            }
        }
        else if (s == "btl" || s == "bottle")
        {
            if (part1 == "")
            {
                part1 = "btl_";
            }
            else
            {
                cerr << "ERR: source type already defined try again";
            }
        }
        else if (s == "level" || s == "lvl")
        {
            if (part2 == "")
            {
                part2 = "lvl";
            }
            else
            {
                cerr << "ERR: function has already been defined" << endl;
            }
        }
        else if (s == "id" || s == "identification" || s == "identifier")
        {
            if (part2 == "")
            {
                part2 = "id";
            }
            else
            {
                cerr << "ERR: function has already been defined" << endl;
            }
        }
        else if (s == "battery" || s == "btr")
        {
            if (part2 == "")
            {
                part2 = "btr";
            }
            else
            {
                cerr << "ERR: function has already been defined" << endl;
            }
        }
    }

    if (part1 == "bvg")
    {
        if (part2 == "btr")
        {
            cerr << "ERR: mismatch between source type and function" << endl;
        }
    }
    else if (part1 == "btl")
    {
        if (part2 != "btr")
        {
            cerr << "ERR: mismatch between source type and function" << endl;
        }
    }

    processedId = part1 + part2;

    return processedId;
}
vector<string> split(string str)
{
    char del[] = {' ', '_', '-', ','};
    vector<string> splittedStr;
    string section = "";
    for (char c : str)
    {
        if ((c == del[0] || c == del[1] || c == del[2] || c == del[3]) && section != "")
        {
            splittedStr.push_back(section);
            section = "";
        }
        section += c;
    }
    return splittedStr;
}
string stringToLower(string str)
{
    string processStr = "";
    for (char c : str)
    {
        if (c >= 65 && c <= 90) // capitol letter
        {
            processStr += char(c + 32);
        }
        else
        {
            processStr += c;
        }
    }
    return processStr;
}

int main(int argc, char **argv)
{

    return 0;
}