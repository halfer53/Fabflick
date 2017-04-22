
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

function ErrorMsg(id,mesg){
    $(id).html("<div class='alert alert-warning' role='alert'>"+mesg+"</div>");
}

function success(id){
    $(id).hide();
    $(id).html("<div class='text-center h3 mb-30' role='alert'>Success</div>");
    $(id).fadeIn();
    $(id).fadeOut();
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
    var objects = JSON.parse(localStorage.getItem("Cart"));
    var title = $('#th-'+id).attr("title");
    console.log(title);
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
    var firstname = document.getElementById("firstname-input").value;
    var lastname = document.getElementById("lastname-input").value;
    var expiration = document.getElementById("expiration-input").value;
    var moviesid = [];
    
    for(var i=0;i<arr.length;i++){
        moviesid.push(arr[i].id);
    }
    $.ajax({
        type: "GET",
        url: "/fabflix/servlet/CheckCreditCard",
        data: {
            firstname: firstname,
            lastname:lastname,
            expiration: expiration,
            moviesid:moviesid
        },
        success: function(data){
            success("#message");
            window.location.href = "/fabflix/jsp/PaymentSuccess.jsp";
        },
        error: function(xhr, ajaxOptions, thrownError){
            ErrorMsg("#message","Credit Card Not Found");
        }
    })
}
