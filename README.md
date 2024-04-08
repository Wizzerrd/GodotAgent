LLM integration in Godot Engine using Eidolon AI SDK

### Demo Prerequisites
* Godot Engine v4.x OR Windows OS
* Docker

### Demo Instructions
1) Using Docker, pull the image ```wizzerrd/godot-agent``` using the command
  ```
  docker pull wizzerrd/godot-agent
  ```
* or build an image locally from the ```/agent``` directory of the repository using the command
```
docker build -t godot-agent .
```
2) Run the image in a container using the command
```
docker run -p 8080:8080 -e OPENAI_API_KEY={your OpenAI API Key} godot-agent
```
* this starts an instance of an Eidolon AI Agent server, running on port 8080
3) Open the ```/engine``` directory in the Godot Engine and run the project, or run the executable located in ```/export/{your OS}```
* NOTE: At the moment only Windows has an exported executable
4) Chat with a pirate in Godot!
