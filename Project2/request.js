var username = "";
var password = "";

function openlogin(){
    if(username == "" && password == ""){
        showLoginINFO();
    }
    else{
        username = "";
        password = "";
        //clear the user cookie
    }
    
}

//display the LoginINFO
function showLoginINFO(){
    //remove the hidden classname
    var loginINFO = document.getElementById("loginINFO");
    loginINFO.className = "loginINFO";
}

//display log in on openlogin button
function displayLogIn(){
    //change button oplogin's appearance to Log In
    var openlogin = document.getElementById("openlogin");
    openlogin.innerHTML = "Sign In";
}
//hide LoginINFO
function hideLoginINFO(){
    //hide the Login session, and change button oplogin's appearance to Log out
    var loginINFO = document.getElementById("loginINFO");
    loginINFO.className = "loginINFO hidden";
    var openlogin = document.getElementById("openlogin");
    openlogin.innerHTML = "Sign Out";
}
        