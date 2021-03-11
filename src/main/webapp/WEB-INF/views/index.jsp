<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
    <script type="text/javascript" src="webstomp.js"></script>
</head>
<body>
<div id="connect-container" class="ui" centered grid>
    <div class="row">
        <button id="connect" onclick="connect()" class="ui green button">Connect</button>
        <button id="disconnect" disabled="disabled" onclick="disconnect()" class="ui red button">Disconnect</button>
    </div>
    <div class="row">
        <textarea id="message" style="width: 350px;" class="ui input" placeholder="Message to Echo"></textarea>
    </div>
    <div class="row">
        <button id="echo" onclick="echo()" disabled="disabled" class="ui button">Echo message</button>
    </div>
</div>
<div id="console-container">
    <h3>Logging</h3>
    <div id="logging"></div>
</div>
<script>
var ws = null;
var url = "ws://localhost:8080/echo-endpoint";

function setConnected(connected) {
    document.getElementById("connect").disabled = connected;
    document.getElementById("disconnect").disabled = !connected;
    document.getElementById("echo").disabled = !connected;
}

function connect() {
    ws = webstomp.client(url);
    ws.connect({}, function(frame) {
        setConnected(true);
        log(frame);
        ws.subscribe('/topic/echo', function(message) {
            log(message.body);
        });
    });
}

function disconnect() {
    if (ws != null) {
        ws.close();
        ws = null;
    }

    setConnected(false);
}

function echo() {
    if (ws != null) {
        var message = document.getElementById("message").value;
        console.log(message);
        log('Sent: ' + message);
        ws.send(message);
    } else {
        alert("connection not established, please connect!");
    }
}

function log(message) {
    var console = document.getElementById("logging");
    var p = document.createElement("p");
    p.appendChild(document.createTextNode(message));
    console.appendChild(p);
    while(console.childNodes.length > 12) {
        console.removeChild(console.firstChild);
    }
    console.scrollTop = console.scrollHeight;
}
</script>
</body>
</html>