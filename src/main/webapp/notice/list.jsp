<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/ssi/ssi_notice.jsp" %> 
<jsp:useBean id="dao" class="com.notice.NoticeDAO" />

<%
//검색부분
	String col = Utility.checkNull(request.getParameter("col"));
	String word = Utility.checkNull(request.getParameter("word"));
	
	if(col.equals("total")) word = "";
	
	
	//페이지 처리 
	int nowPage = 1; //현제 페이지 
	if(request.getParameter("nowPage")!=null){
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	
	int recordPerPage = 10; //한페이지당 보여줄 레코드 갯수 -> 디비에서 가져올 갯수
	
	int sno = (nowPage-1) * recordPerPage;  //디비에서 가져올 시작 레코드 순번
	
	Map map = new HashMap();
	map.put("col",col);
	map.put("word", word);
	map.put("sno", sno);
	map.put("eno", recordPerPage);

	List<NoticeDTO> list = dao.list(map);
	
	int total = dao.total(col, word);
	
	String url = "list.jsp";
	
	String paging = Utility.paging(total, nowPage, recordPerPage, col, word, url);
%>  
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script>
// JavaScript 함수를 정의하여 마우스 오버 이벤트 처리
function highlightTitle(titleElement) {
  titleElement.style.color = 'orange'; // 주황색으로 변경
  titleElement.style.fontWeight = 'bold'; // 볼드 처리 추가

}

// JavaScript 함수를 정의하여 마우스 아웃 이벤트 처리
function unhighlightTitle(titleElement) {
  titleElement.style.color = ''; // 원래 색상으로 변경 (비움)
  titleElement.style.fontWeight = ''; // 볼드 처리 추가

}

function read(bbsno){
	let url = "read.jsp";
	url += "?bbsno="+bbsno;
	url += "&nowPage=<%=nowPage%>";
	url += "&col=<%=col%>";
	url += "&word=<%=word%>";
	
	location.href=url;
}

function onMouseOverTitle(element) {
    element.style.color = 'red'; // 마우스 오버 시 텍스트 색상 변경
    element.style.fontSize = '25px'; // 마우스 오버 시 텍스트 크기 증가
    element.style.backgroundColor = 'yellow'; // 마우스 오버 시 배경색 변경
}

function onMouseOutTitle(element) {
    element.style.color = 'black'; // 마우스 아웃 시 원래 색상으로 변경
    element.style.fontSize = '16px'; // 마우스 아웃 시 원래 크기로 변경
    element.style.backgroundColor = 'white'; // 마우스 아웃 시 원래 배경색으로 변경
}
</script>
<style>
/* 테이블 헤더 배경색을 초록색으로 변경 */
thead {
  background-color: #ffffff;	
}
</style>
</head>
<body>
<jsp:include page="/menu/top.jsp"/>
<div class='container mt-3'>
 <h2>공지사항 목록</h2>
 <form action="list.jsp">
 <div class="row mb-3 mt-3"> 
   <div class="col">  
     <select class="form-select"  name="col">
      <option value="wname" 
      <% if(col.equals("wname")) out.print("selected");%>
      >성명</option>
      <option value="title" 
      <% if(col.equals("title")) out.print("selected");%>
      >제목</option>
      <option value="content"
      <% if(col.equals("content")) out.print("selected");%>
      >내용</option>
      <option value="title_content" 
      <% if(col.equals("title_content")) out.print("selected");%>
      >제목+내용</option>
      <option value="total"
      <% if(col.equals("total")) out.print("selected");%>
      >전체출력</option>
    </select>
   </div>
   <div class="col">
       <input type="search" class="form-control" name="word" required="required" value="<%=word%>">
   </div>
   <div class="col">
    <button type="submit" class="btn btn-primary">검색</button>
    <button type="button" class="btn btn-primary" onclick="location.href='createForm.jsp'">등록</button>
   </div>
  </div>
  </form>        
  <table class="table table-striped">
    <thead>
      <tr >
        <th>번호 </th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회수</th>
        <th>등록날짜 </th>
        <th>grpno</th>
        <th>indent</th>
        <th>ansnum </th>
      </tr>
    </thead>
    <tbody>
    
<% if(list.size() == 0) { %>
      <tr><td colspan = '8'>등록된 글이 없습니다.</td></tr>   
<% }else{
	
   for(int i=0; i<list.size(); i++){
	  NoticeDTO dto = list.get(i); 
%>  
      <tr>
        <td><%=dto.getBbsno() %></td>
        <td class="title" onmouseover="onMouseOverTitle(this)" onmouseout="onMouseOutTitle(this)">
    <%
    for (int r = 0; r < dto.getIndent(); r++) {
        out.print("&nbsp;&nbsp;");
    }
    if (dto.getIndent() > 0) {
        out.print("<img src='../images/re.jpg'>");
    }
    %>
    <a href="javascript:read('<%=dto.getBbsno() %>')" 
     onmouseover="highlightTitle(this)" 
     onmouseout="unhighlightTitle(this)">
    <%=dto.getTitle() %>
    <% if(Utility.compareDay(dto.getWdate())) { %>
      <img src='../images/new.gif'>
    <% } %>
  </a>
</td>
        <td><%=dto.getWname() %></td>
        <td><%=dto.getViewcnt() %></td>
        <td><%=dto.getWdate() %></td>
       <td><%=dto.getGrpno() %></td>
        <td><%=dto.getIndent() %></td>
        <td><%=dto.getAnsnum() %></td>
      </tr>
<%   }  //for end 
	} //if end
%>
   </tbody>  
  </table>
   <%=paging %>
</div>
</body>
</html>
