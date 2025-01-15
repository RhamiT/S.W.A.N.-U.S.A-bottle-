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
// Helper functions appart .h file

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
            continue;
        }
        section += c;
    }
    splittedStr.push_back(section);
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
string dataProcessID(string id)
{
    /*
        "source_function"
        source = bvg, btl
        function = lvl,id || battery

        user must put in valid source entry w\out regarding capitalization (beverage,bvg,ultrasonic, || bottle,btl)
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
        if (s == "bvg" || s == "beverage" || s == "ultrasonic" || s == "ls" || s == "lightsensor")
        {
            part1 = "bvg";
        }
        else if (s == "btl" || s == "bottle")
        {
            part1 = "btl";
        }
        else if (s == "btr" || s == "battery" || s == "charge" || s == "chrg")
        {
            part2 = "btr";
        }
        else if (s == "lvl" || s == "level")
        {
            part2 = "lvl";
        }
        else if (s == "id" || s == "identification")
        {
            part2 = "id";
        }
        else
        {
            cerr << "ERR: " << s << " is an invalid value! aborting please try again" << endl;
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

    processedId = part1 + "_" + part2;
    return processedId;
}

// .h functions
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
string fileCreator::genJson()
{
    string bvg_content = "";
    string btl_content = "";
    // bvg data
    bvg_content += "bvg : {";
    for (auto &value : bvg)
    {
        bvg_content += value.first + " : " + value.second + ", ";
    }
    bvg_content += "},\n";
    btl_content += "btl : {";
    for (auto &value : bottle)
    {
        btl_content += value.first + " : " + value.second + ", ";
    }
    btl_content += "},\n";
    return ("{\n" + bvg_content + btl_content + "}");
}