Welcome to the GodotAgent Plugin for Godot 4! This is a plugin providing LLM integration in Godot Engine using Eidolon AI SDK

### Features
* Configure an agent with Eidolon and connect it to your game in Godot
* HTTPSSE Streaming for near real-time responses from your agents

### Requirements
* Godot 4.x
* Docker

### Demo Instructions
1) Open ```demo/godot/``` as a project in Godot editor
2) Build Docker image from the file contents in ```demo/eidolon/```

``` docker build -t godot-agent demo/eidolon/ ```

3) Run the Docker image in a container to start the Eidolon server

``` docker run -p 8080:8080 -e OPENAI_API_KEY=<YOUR OPENAI API KEY> ```

5) Run the Godot project. You can verify if the client and server are communicating by checking the Eidolon server logs for a POST request.
6) Game controls are WASD to move, E to talk to the NPC, ESC to exit the conversation.
7) Have a conversation with a knight!

The Agent's behavior can be easily customized by modifying the contents of the ``` system_prompt ``` field of ``` demo/eidolon/resources/npc_agent.yaml ```.

Make sure to re-build your Docker image and restart your container when you make changes to your Agent.

On Mac and Linux, you can run the Eidolon server directly on your machine without using Docker. Follow the [quickstart](https://www.eidolonai.com/docs/getting_started/quickstart/introduction/) tutorial on the [Eidolon AI Website](https://www.eidolonai.com/) to get started.
