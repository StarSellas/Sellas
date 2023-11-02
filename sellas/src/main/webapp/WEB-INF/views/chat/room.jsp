<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>채팅방 리스트</title>
    <style>
        /* 초기에 숨길 스타일 */
        .hidden-element {
            display: none; /* 숨김 */
        }
    </style>
    <script src="../js/jquery-3.7.0.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h3>채팅방 리스트</h3>
            </div>
        </div>
        <div class="input-group">
            <div class="input-group-prepend">
                <label class="input-group-text">방제목</label>
            </div>
            <input type="text" class="form-control" id="room_name" onkeypress="checkEnter(event)">
            <div class="input-group-append">
                <button class="btn btn-primary" type="button" onclick="createRoom()">채팅신청</button>
            </div>
        </div>
        <ul class="list-group" id="chatrooms">
            <c:forEach items="${chatrooms}" var="item">
                <li class="list-group-item list-group-item-action" onclick="enterRoom('${item.roomId}')">${item.name}</li>
            </c:forEach>
        </ul>
    </div>

    <script>
        function createRoom() {
            var roomName = document.getElementById('room_name').value;
        
            if (roomName === "") {
                alert("방 제목을 입력해 주세요.");
                return;
            }

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "/chat/room", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            xhr.onload = function () {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response && response.name) {
                        alert(response.name + " 방 개설에 성공하였습니다.");
                        document.getElementById('room_name').value = '';
                        findAllRoom();
                    } else {
                        alert("채팅방 개설에 실패하였습니다.");
                    }
                } else {
                    alert("서버 오류가 발생했습니다.");
                }
            };
            xhr.send("name=" + roomName);
        }

        function enterRoom(roomId) {
            var sender = prompt('대화명을 입력해 주세요.');
            if (sender !== "") {
                localStorage.setItem('wschat.sender', sender);
                localStorage.setItem('wschat.roomId', roomId);
                location.href = "/chat/room/enter/" + roomId;
            }
        }

        function findAllRoom() {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "/chat/rooms", true);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    var chatrooms = JSON.parse(xhr.responseText);
                    var chatroomsList = document.getElementById("chatrooms");
                    chatroomsList.innerHTML = ""; // Clear the list
                    chatrooms.forEach(function (item) {
                        var li = document.createElement("li");
                        li.className = "list-group-item list-group-item-action";
                        li.textContent = item.name;
                        li.onclick = function () {
                            enterRoom(item.roomId);
                        };
                        chatroomsList.appendChild(li);
                    });
                } else {
                    alert("채팅방 목록을 불러오는데 실패하였습니다.");
                }
            };
            xhr.send();
        }

        function checkEnter(event) {
            if (event.key === "Enter") {
                createRoom();
            }
        }

        findAllRoom(); // 초기 채팅방 목록 로딩
    </script>
</body>
</html>
