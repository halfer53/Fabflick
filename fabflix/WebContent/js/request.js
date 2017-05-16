
function loginRequest(){
    var username = $("#username-input").val();
    var password = $("#password-input").val();
    if(username && password){
        $.ajax({
            type: "POST",
            url: "servlet/Logging",
            data: {
                user_name: username,
                password: password
            },
            success: function(data){
                success("#message");
                window.location.href = "/fabflix/jsp/Main.jsp";
            },
            error: function(xhr, ajaxOptions, thrownError){
                ErrorMsg("#message","Incorrect User name or Password");
            }
        })
    }else{
        ErrorMsg("#message", "Plz provide User name or Password");
    }
}


function employeeLoginRequest(){
    var username = $("#username-input").val();
    var password = $("#password-input").val();
    if(username && password){
        $.ajax({
            type: "POST",
            url: "servlet/EmployeeLogging",
            data: {
                user_name: username,
                password: password
            },
            success: function(data){
                success("#message");
                window.location.href = "/fabflix/admin/Main.jsp";
            },
            error: function(xhr, ajaxOptions, thrownError){
                ErrorMsg("#message","Incorrect User name or Password");
            }
        })
    }else{
        ErrorMsg("#message", "Plz provide User name or Password");
    }
}

function addNewStar(){
    var name = $("#name-input").val();
    var dob = $("#dob-input").val();
    var photo = $("#photo_url-input").val();
    var firstname = '',lastname = '';
    if(name){
    	if(name.split(" ").length >= 2){
    		firstname = name.substr(0,name.indexOf(' '));
        	lastname = name.substr(name.indexOf(' ')+1);
    	}else{
    		lastname = name;
    	}
        $.ajax({
            type: "POST",
            url: "/fabflix/servlet/AddNewStar",
            data: {
                firs_name:firstname,
                last_name:lastname,
                dob:dob,
                photo_url:photo
            },
            success: function(data){
                success("#message");
            },
            error: function(xhr, ajaxOptions, thrownError){
                ErrorMsg("#message",xhr.responseText);
            }
        })
    }else{
        ErrorMsg("#message", "Plz provide at least last name");
    }
}

function addNewAnime(){
    var title = document.getElementById("title").value;
    var year = document.getElementById("year").value;
    var director = document.getElementById("director").value;
    var vafirstname = document.getElementById("vafirstname").value;
    var valastname = document.getElementById("valastname").value;
    var genre = document.getElementById("genre").value;
    if(title && year && director && vafirstname && valastname && genre){
        $.ajax({
            type: "POST",
            url: "/fabflix/servlet/AddNewAnime",
            data: {
                title:title,
                year:year,
                director:director,
                vafirstname:vafirstname,
                valastname,valastname,
                genre:genre
            },
            success: function(data){
                success1("#message",data);
            },
            error: function(xhr, ajaxOptions, thrownError){
                ErrorMsg("#message","Plz provide a number");
            }
        })
    }else{
        ErrorMsg("#message", "Plz provide proper data");
        $("#message").fadeOut();
    }
}

$('#search-anime').submit(function () {
    var x = document.getElementById("year-input").value;
    if(!parseInt(x)&&x!==''){
        alert("Plz enter a valid number for year input");
        return false;
    }
    $(this)
        .find('input[name]')
        .filter(function () {
            return !this.value;
        })
        .prop('name', '');
});

function ErrorMsg(id,mesg){
    document.getElementById("message").innerHTML = "<div class='alert alert-warning' role='alert'>"+mesg+"</div>";
}

function success(id){
    $(id).hide();
    $(id).html("<div class='text-center h3 mb-30' role='alert'>Success</div>");
    $(id).fadeIn();
    $(id).fadeOut();
}
function success1(id,data){
    $(id).hide();
    $(id).html("<div class='text-center h3 mb-30' role='alert'>"+data+"</div>");
    $(id).fadeIn();
}

function requestSort(className,data){
    url = window.location.search;
    var result = url.replace(/[&]?sortby=[a-z]+/g,'');
    result = result.replace(/[&]?sorttype=[a-z]+/g,'');
    result+= "&sortby="+data;
    if(className === "sortable asc"){
        result+= "&sorttype=desc";
    }else{
        result+= "&sorttype=asc";
    }
    if(result.charAt(0) != '?'){
        result = '?' + result;
    }
    window.location.href=  window.location.pathname+result;
}

function changePageItemNum(num){
    url = window.location.search;
    var result = url.replace(/[&]?limit=[0-9]+/g,'');
    result = result.replace(/[&]?page=[0-9]+/g,'');
    result+= "&limit="+num;
    if(result.charAt(0) != '?'){
        result = '?' + result;
    }
    window.location.href=  window.location.pathname+result;
}

function addToCartByInput(id){
    var quantity = parseInt($('#th-'+id).val());
    if(!quantity){
        alert("Plz Enter a valid number");
        return;
    }
    var title = $('#th-'+id).attr("title");
    addToCartByAttr(id,quantity,title);
}

function addToCartByAttr(id,quantity,title){
    var objects = JSON.parse(localStorage.getItem("Cart"));
    if(objects == null){
        objects = [];
        objects.push({ id:id,quantity:quantity,title:title});
    }else{
        var found = false;
        for(var i=0;i<objects.length;i++){
            if(objects[i].id == id){
                found = true;
                objects[i].quantity += quantity;
            }
        }
        if(!found){
            objects.push({ id:id,quantity:quantity,title:title});
        }
    }
    console.log(objects);
    localStorage.setItem("Cart",JSON.stringify(objects));
    success("#message");
}

function getCart(){
    var result = "";
    var arr = JSON.parse(localStorage.getItem("Cart"));
    for(var i=0;i<arr.length;i++){
        result += "<tr>" + "<td>" + arr[i].title + "</td>" + 
                    "<td><input type='text' class='form-control' aria-label='...' maxlength='3' size='3' id=\"th-"+ arr[i].id +"\" value ='"+arr[i].quantity+"'></td>"+
                    "<td><button type='button' class='btn btn-defaul' onclick='updateCartByID("+ arr[i].id+ ")'>Update</button> </td>" +
                    "<td><button type='button' class='btn btn-default' onclick='deleteCartByID("+ arr[i].id+ ")'>Delete</button> </td>" +
                "</tr>";
    }
    return result;
}

function deleteCartByID(id){
    var arr = JSON.parse(localStorage.getItem("Cart"));
    arr = arr.filter(function(el) {
        return el.id != id;
    });
    localStorage.setItem("Cart",JSON.stringify(arr));
    $("#Cart-data").html(getCart());
}

function updateCartByID(id){
    var arr = JSON.parse(localStorage.getItem("Cart"));
    var quantity = parseInt($('#th-'+id).val());
    if(!quantity){
        alert("Plz Enter a Valid Number");
        return;
    }
    var i=0;
    while(i<arr.length && arr[i].id != id){ i++;}
    if(i < arr.length){
        arr[i].quantity = quantity;
        localStorage.setItem("Cart",JSON.stringify(arr));
    }
    success("#message");
    
}

function checkout(uid){
    if(!uid){
        alert("Plz login first");
        return;
    }
    var arr = JSON.parse(localStorage.getItem("Cart"));
    if(!arr || arr.length==0){
        alert("Plz add some items to your cart");
        return;
    }
    window.location.href=  "/fabflix/jsp/Checkout.jsp";
}

function checkCreditCard(uid){
    var arr = JSON.parse(localStorage.getItem("Cart"));
    if(!uid){
        alert("Plz login first");
        return;
    }
    if(!arr || arr.length==0){
        alert("Plz add some items to your cart");
        return;
    }
    var id = document.getElementById("id-input").value;
    var firstname = document.getElementById("firstname-input").value;
    var lastname = document.getElementById("lastname-input").value;
    var expiration = document.getElementById("expiration-input").value;
    var animesid = [];
    
    for(var i=0;i<arr.length;i++){
        animesid.push(arr[i].id);
    }
    $.ajax({
        type: "GET",
        url: "/fabflix/servlet/CheckCreditCard",
        data: {
            id: id,
            firstname: firstname,
            lastname:lastname,
            expiration: expiration,
            animesid:animesid
        } 
    }).done(function(data){
        success("#message");
        window.location.href = "/fabflix/jsp/PaymentSuccess.jsp";
    }).fail(function(jqXHR, textStatus, errorThrown){
        document.getElementById("message").innerHTML = "<div class='alert alert-warning' role='alert'>Credit Card Not Found</div>";
    });
}
$.fn.clicktoggle = function(a, b) {
    return this.each(function() {
        var clicked = false;
        $(this).click(function() {
            if (clicked) {
                clicked = false;
                return b.apply(this, arguments);
            }
            clicked = true;
            return a.apply(this, arguments);
        });
    });
};
$(".more").clicktoggle(function() {
  $(this).text("less..").siblings(".complete").show();
}, function() {
  $(this).text("more..").siblings(".complete").hide();
});

