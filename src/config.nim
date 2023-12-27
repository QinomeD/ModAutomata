import termstyle
import std/[rdstdin, strutils]

var projectPath*: string
var projectName*: string

proc writeToConfig*(config: File, attribute: string, prefix: string, prompt: string) = 
    config.writeLine(attribute & " = " & prefix & readLineFromStdin(prompt))

proc getConfigValue*(config: File, attribute: string): string = 
    for line in config.lines:
        if line.contains(attribute):
            return line.substr(line.find('=')+1, line.find('\n'))
    
    echo red "ERROR: Tried to get an invalid attribute " & attribute