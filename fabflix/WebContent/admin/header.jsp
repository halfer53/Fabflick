    <%
        Integer uid = (Integer)session.getAttribute("uid");
        String page_name = request.getRequestURI().substring(request.getContextPath().length());
        page_name = page_name.substring(7);//remove /jsp/
    %>

    <%!
        private String getHeaderClass(String pagename,String url){
            return url.equals(pagename) ? "class=\"active\" " : "";
        }
    %>
    <div class="container-fluid mb-70">
        <nav class="navbar navbar-default navbar-fixed-top"> 
            <div class="container-fluid"> <div class="navbar-header"> 
                <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-6" aria-expanded="false"> 
                <span class="sr-only">Toggle navigation</span> 
                <span class="icon-bar"></span>
                 <span class="icon-bar"></span> 
                 <span class="icon-bar"></span> 
                 </button> <a href="/fabflix/jsp/Main.jsp" class="navbar-brand">Fabflix</a> 
            </div>
             <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-6"> 
             <ul class="nav navbar-nav"> 
                 <li <%=getHeaderClass("Main.jsp",page_name)%>><a href="/fabflix/admin/Main.jsp">Main</a></li>
                 <li <%=getHeaderClass("addAnime.jsp",page_name)%>><a href="/fabflix/admin/addAnime.jsp">Add Anime</a></li>
             </ul> 
             </div> 
            </div> 
            <div id="message"></div>
        </nav>
    </div>