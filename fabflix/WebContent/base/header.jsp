    <%
        Integer uid = (Integer)session.getAttribute("uid");
        String page_name = request.getRequestURI().substring(request.getContextPath().length());
        page_name = page_name.substring(5);//remove /jsp/
    %>

    <%!
        private String getHeaderClass(String pagename,String url){
            return url.equals(pagename) ? "class=\"active\" " : "";
        }
        private String getRightButton(Integer uid,String page_name){
            if(uid == null){
                return "<li "+getHeaderClass("ShoppingCart.jsp",page_name)+"><a href='/fabflix'>Login</a></li> ";
            }
            return "<li "+getHeaderClass("ShoppingCart.jsp",page_name)+"><a href='/fabflix/jsp/ShoppingCart.jsp'>Checkout</a></li> ";

        }
    %>
    <div class="container-fluid mb-70">
        <nav class="navbar navbar-default navbar-fixed-top"> 
            <div class="container-fluid"> 
            <div class="navbar-header"> 
                <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-6" aria-expanded="false"> 
                <span class="sr-only">Toggle navigation</span> 
                <span class="icon-bar"></span>
                 <span class="icon-bar"></span> 
                 <span class="icon-bar"></span> 
                 </button> <a href="/fabflix/jsp/Main.jsp" class="navbar-brand">Fabflix</a> 
            </div>
             <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-6"> 
	             <ul class="nav navbar-nav"> 
	                 <li <%=getHeaderClass("Main.jsp",page_name)%>><a href="/fabflix/jsp/Main.jsp">Main</a></li>
	                 <li <%=getHeaderClass("Browse.jsp",page_name)%>><a href="/fabflix/jsp/Browse.jsp">Browse</a></li>
	                 <li <%=getHeaderClass("Anime.jsp",page_name)%>><a href="/fabflix/jsp/Anime.jsp">Animes</a></li> 
	                 <li <%=getHeaderClass("Search.jsp",page_name)%>><a href="/fabflix/jsp/Search.jsp">Search</a></li>
	                 <%=getRightButton(uid,page_name)%>
	             </ul> 
	             <form class="navbar-form navbar-left">
				  <div class="input-group ui-widget">
				    <input type="text" class="form-control" placeholder="Search" id="search-box">
				  </div>
				</form>
             </div> 
             
             	
             
            </div> 
            <div id="message"></div>
        </nav>
    </div>