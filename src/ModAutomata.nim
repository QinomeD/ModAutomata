# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import termstyle
import std/[os, rdstdin]

proc setupAutomataDir(path: string) = 
  discard existsOrCreateDir(path / ".automata")
  let config = open(path / ".automata" / "config.automata", fmWrite)
  defer: config.close()

  config.writeLine("mainPath = " & "src/main/java/" & readLineFromStdin(yellow bold "Main package path (typically smth like \"com/qinomed/mycoolmod\"): \n> "))

  echo green "Setup complete!"
  

proc openProject(path: string) = 
  echo "Loading project..."
  if not dirExists(path):
    echo red "Path does not exist!"
    quit(1)
  
  if not dirExists(path / "src"):
    echo red "Invalid project!"
    quit(1)
  
  if not fileExists(path / ".automata" / "config.automata"):
    echo "Automata config not found, starting setup..."
    setupAutomataDir(path)

when isMainModule:
  let paramCount = paramCount()

  if paramCount < 1:
    echo "Usage: modautomata COMMAND [cmdopts]\n",
        green "Commands: \n",
        "  create  [name]        #  Creates a new mod project\n",
        "  open    [path]        #  Opens a directory as a mod project.\n"
    quit(1)

  let args = commandLineParams()
  
  case args[0]
    of "open":
      if paramCount < 2:
        echo red "No path provided!"
        quit(1)
      openProject(args[1].normalizePathEnd())
