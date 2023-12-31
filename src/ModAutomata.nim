import termstyle
import automata_shell
import config
import std/[os]

# Setup config
proc setupAutomataDir(path: string) = 
  discard existsOrCreateDir(path / ".automata")
  let config = open(path / ".automata" / "config.automata", fmWrite)
  defer: config.close()

  config.writeToConfig("mainPath", "src/main/java/", yellow bold "Main package path (Example: \"com/qinomed/mycoolmod\"): \n> ")
  config.writeToConfig("itemRegistry", mainPath, yellow bold "Item registry class (Example: \"item/ModItems\"): \n> ")

  echo green "Setup complete!"
  

proc openProject() = 
  echo "Loading project..."
  if not dirExists(projectPath):
    echo red "Path does not exist!"
    quit(1)
  
  if not dirExists(projectPath / "src"):
    echo red "Invalid project!"
    quit(1)
  
  if not fileExists(projectPath / ".automata" / "config.automata"):
    echo "Automata config not found, starting setup..."
    setupAutomataDir(projectPath)
  
  startShell()


# Main
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
      projectPath = args[1].normalizePathEnd()
      projectName = tailDir(projectPath)
      openProject()
