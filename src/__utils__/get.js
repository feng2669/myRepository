<script type="text/javascript"> 
/* 创建 XMLHttpRequest 对象 */
var xmlHttp; 
function GetXmlHttpObject(){ 
　　if (window.XMLHttpRequest){ 
　　　　// code for IE7+, Firefox, Chrome, Opera, Safari 
　　　　xmlhttp=new XMLHttpRequest(); 
　　}else{// code for IE6, IE5 
　　　　xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); 
　　} 
　　return xmlhttp; 
} 
// -----------ajax方法-----------// 
function getLabelsGet(){ 
　　xmlHttp=GetXmlHttpObject(); 
　　if (xmlHttp==null){ 
　　　　alert('您的浏览器不支持AJAX！'); 
　　　　return; 
　　} 
　　var id = document.getElementById('id').value; 
　　var url="http://www.Leefrom.com?id="+id+"&t/"+Math.random(); 
　　xmlHttp.open("GET",url,true); 
　　xmlHttp.onreadystatechange=favorOK;//发送事件后，收到信息了调用函数 
　　xmlHttp.send(); 
}
function getOkGet(){ 
　　if(xmlHttp.readyState==1||xmlHttp.readyState==2||xmlHttp.readyState==3){ 
　　　　// 本地提示：加载中 
　　} 
　　if (xmlHttp.readyState==4 && xmlHttp.status==200){ 
　　　　var d= xmlHttp.responseText; 
　　　　// 处理返回结果 
　　} 
} 
</script>