<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/ssi/ssi_notice.jsp" %> 
<jsp:useBean id="dao" class="com.notice.NoticeDAO"/>  
<jsp:useBean id="dto" class="com.notice.NoticeDTO" /> 
<jsp:setProperty name="dto" property="*"/>
<%
Map map = new HashMap();
map.put("bbsno", dto.getBbsno());
map.put("passwd", dto.getPasswd());
boolean pflag = dao.passCheck(map);
boolean flag = false;
if(pflag)
    flag = dao.update(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정 결과</title>
</head>
<body>
<jsp:include page="/menu/top.jsp" />
<div class="container">
<div class="container p-5 my-5 border">
    <%
        if(!pflag){
            out.println("패스워드 오류 입니다.");
        }else if(flag){
            out.println("글 수정 성공 입니다.");
        }else{
            out.println("글 수정 실패 입니다.");
        }
    %>
</div>
    <% if(!pflag) { %>
    <button class="btn btn-light" onclick="history.back()">다시시도</button>
    <% } %>
    <button class="btn btn-light" onclick="location.href='createForm.jsp'">다시등록</button>
    <button class="btn btn-light" onclick="location.href='list.jsp'">목록</button>
</div>
</body>
</html>
