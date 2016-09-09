<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<!-- 引入js-->
	<script type="text/javascript" src="../scripts/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="../scripts/jquery-timepicker/jquery.timepicker.min.js"></script>
	<link href="../scripts/jquery-timepicker/jquery.timepicker.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="../scripts/bootstrap3.0.3/js/bootstrap.min.js"></script>
	<!-- <script type="text/javascript" src="../scripts/echarts-2.2.7/build/source/echarts.js"></script> -->
	<script src="../scripts/runningdata-echarts.js"></script>
	<script src="http://www.imooc.com/data/jquery-ui-1.9.2.min.js" type="text/javascript"></script>
	
	
	<!-- 引入CSS -->
	<link href="../css/taveenstyle.css" rel="stylesheet" type="text/css" />
	<link href="../css/style.css" rel="stylesheet" type="text/css" />
	<link href="http://www.imooc.com/data/jquery-ui.css" rel="stylesheet" type="text/css" />
	
	
	<!-- 引入Bootstrap -->
	<link href="../css/bootstrap.min.css" rel="stylesheet">
	<!-- 引入按钮样式 -->
	<link href="../css/buttonstyle.css" rel="stylesheet">
	<!-- 引入 ECharts 文件 -->
    <script src="../scripts/echarts.js"></script>
    
    <!-- 引入artDialog插件 -->
    <script src="../scripts/dialog-min.js"></script>
    <link rel="stylesheet" href="../css/ui-dialog.css">
	
	
<script type="text/javascript">

var singleVideoSelectedType = "",
	singleVideoSelectedWebname = "",
	singleVideoSelectedName = "",
	singleVideoSelectedUrl = "";


var statusShow = new Array(10), 
	statusTmp = new Array(10);

function getNameString(strs , num){
	if(strs.length > num){
		return strs.substring(0, num) + "...";
	}
	return strs;
}

function getUrlString(url , num){
	if(url.length > num){
		return url.substring(0, num) + "...";
	}
	return url;
}

function changeToHanzi(status){
	if(status == "doing"){
		return "运行中";
	}else if(status == "pending"){
		return "排队";
	}else if(status == "error"){
		return "错误";
	}else if(status == "done"){
		return "完成";
	}else if(status == "stop"){
		return "停止";
	}
}

function changeWebsiteToZh(name) {
	switch(name) {
	case 'youku':
		return '优酷';
		break;
	case 'tudou':
		return '土豆';
		break;
	case 'letv':
		return '乐视';
		break;
	case 'qiyi':
		return '爱奇艺';
		break;
	case 'sohu':
		return '搜狐';
		break;
	case 'qq':
		return '腾讯';
		break;
	case 'cntv':
		return 'cntv';
		break;
	case 'brtn':
		return 'brtn';
		break;
	case 'local':
		return '本地';
		break;
	}
}

function changeWeekdayToZh(name){
	switch(name) {
	case 'mon':
		return '周一';
		break;
	case 'tue':
		return '周二';
		break;
	case 'wed':
		return '周三';
		break;
	case 'thu':
		return '周四';
		break;
	case 'fri':
		return '周五';
		break;
	case 'sat':
		return '周六';
		break;
	case 'sun':
		return '周日';
		break;
	}
}



function statusRequest(){
	
	/* var date =  new Date();
	console.log(date.toString()); */
	
	var videoListUrl = "/TaveenConsole/video/tasklist";
	
	var pageValue = parseInt($("#task-latest-current-page-span").text()) - 1;
	var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), status : 4 , flag : encodeURI("1") };
	
	var st = $("#hidden-st-latest").val();
	var ed = $("#hidden-ed-latest").val();
	var numDay = $("#hidden-num-latest").val();
	if(st != 0){
		paramsValue.st = st;
	}
	if(ed != 0){
		paramsValue.ed = ed;
	}
	if(numDay != 0){
		paramsValue.num = numDay;
	}
	
	//console.log(paramsValue);
	
	$.get(videoListUrl, paramsValue, function(data, status) {
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			$.each(jsonObj.ret_info.jobs, function(n,value) {
				//console.log(value.status);
				statusTmp[n] = changeToHanzi(value.status);
			});
			
			for(var i = 0; i < 10; i++){
				if(statusTmp[i] != statusShow[i]){ //这里只会由  排队/运行中  转化成为   完成/错误
					var s = "#status-" + i;
					//$(s).text(statusTmp[i]);
					
					if(statusTmp != '错误'){
						$(s).text(statusTmp[i]);	
					}else{
						var errtrs = "<a href = '#' onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'>错误</a>";;
						$(s).text(errtrs);
					}
					
				}
			}
		}
	});

}

	var statusTimer;


function showTaskList(type){
	
	
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-" + type + "-list-form").show();
	
	var statusCode = 0;
	if(type == "running"){
		statusCode = 1;
	}else if(type == "finished"){
		statusCode = 2;
	}else if(type == "report" || type == "multiReport"){
		statusCode = 3;
	}else if(type == "latest"){
		// 全部
		statusCode = 4;
	}
	
	// 当前页面
	var pageValue = parseInt($("#task-" + type + "-current-page-span").text()) - 1;
	var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), status : statusCode , flag : encodeURI("1") };
	
	var st = $("#hidden-st-" + type).val();
	var ed = $("#hidden-ed-" + type).val();
	var numDay = $("#hidden-num-" + type).val();
	if(st != 0){
		paramsValue.st = st;
	}
	if(ed != 0){
		paramsValue.ed = ed;
	}
	if(numDay != 0){
		paramsValue.num = numDay;
	}
	
	var videoListUrl = "/TaveenConsole/video/tasklist";
	$.get(videoListUrl, paramsValue, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		// 清空内容
		$("#task-" + type + "-list-tbody").empty(); 
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			// 设置总页面数，和当前页面值 666
			var totalPage = 0;
			if(jsonObj.ret_info.total_count % 10 == 0){
				totalPage = jsonObj.ret_info.total_count /10;
			}else{
				totalPage = Math.floor(jsonObj.ret_info.total_count / 10) + 1;
			}
			
			$("#task-" + type + "-total-count-span").text(totalPage);
			
			if(type != "report" && type != "multiReport"){//为了把report中的multi部分提出来同时不影响其他页面的showTaskList
				$.each(jsonObj.ret_info.jobs, function(n,value) {
					
					var taskIndex = pageValue*10 + n + 1;
					//console.log("latest: pageVaule " + pageValue + ", n: " + n);
					var taskFlag = value.flag;
					//console.log(taskFlag);
					var node_name = value.node_name;
					trs += "<tr><td>" + taskIndex + "</td><td>"
							//+ getNameString(value.name , 15) + "</td><td>"
							//+ getNameString(value.name) + "</td><td>"
							+ "<span title='" + getNameString(value.name) + "'>" + getNameString(value.name , 15) + "</span>" + "</td><td>"
							
							+ value.website + "</td><td class='address'>"
							+ "<a href='" + value.url +"' target='_blank' data-url=" + value.url + ">" + getUrlString(value.url , 45) + "</a>" 
							+ "<div>" + value.url + "</div></td><td>"
							+ node_name + "</div></td><td>";
					/* if(taskFlag == "yes"){
						//console.log(value.autojob_id);
						var multi_job_id = value.autojob_id;
						trs += "<a data-toggle='modal' href='#multiInfoModal' onclick=\"showMultiInfoModal('" + multi_job_id + "')\">查看</a>"
					} */
					
					//trs += "</td><td>";
							
					if(value.st != "null" && value.st != null){
						trs += value.st	+ "</td><td>";
					}else{
						trs += "</td><td>";
					}
					if(value.ed != "null" && value.ed != null){
						trs += value.ed	+ "</td><td id='status-" + n + "'>"; //td 加id属性
					}else{
						trs += "</td><td id='status-" + n + "'>"; //td 加id属性
					}
					
					if(value.status == "error"){
						trs += "<a href = '#' onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'>错误</a>";
					}else{
						trs += changeToHanzi(value.status) + "</td>";	
					}
					
					
					/* if(type == "report"){	 // 测量结果
						trs += "<td>";
						trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\" value='" + value.job_id + "' title='查看报告'/><span>";
						trs += "&nbsp;";
						trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
						trs += "&nbsp;";
						trs += "</td><td>";
						trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
						
						trs += "</td>";
					}else*/
					if(type == "finished"){ // 所有任务
						if(value.status == "stop" || value.status == "done" || value.status == "error"){//需要任务查看和任务操作的地方
							trs += "<td>";
							if(value.status == "error"){
								//trs += "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale'  onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'/></span>";
							}else{
								trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看报告'/></span>";
								trs += "&nbsp;";
								trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							}
							trs += "&nbsp;";
							trs += "</td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs += "</td>";
						}else{//只需要任务操作 不需要任务查看的地方
							trs +="<td></td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs +="</td>"
						}
					}else if(type == "latest"){ // 最新任务 
						if(value.status == "stop" || value.status == "done" || value.status == "error"){//需要任务查看和任务操作的地方
							trs += "<td>";
							if(value.status == "error"){
								//trs += "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale'  onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'/></span>";
							}else{
								trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看报告'/></span>";
								trs += "&nbsp;";
								trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							}
							trs += "&nbsp;";
							trs += "</td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs += "</td>";
						}else{//运行中 排队
							trs += "<td>";
							trs += "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale' onclick=\"showRunningDataReport('" + value.job_id + "')\" data-toggle='modal' data-target='#runningDataReportModal' value='" + value.job_id + "' title='运行数据'/></span>";
							trs += "</td><td>";
							trs += "<span class='image_change'><img data-src='../images/stop.png' src='../images/stop-2.png' class='img-scale' onclick=\"stopVideoTask('" + value.job_id + "', 'latest' , -2)\" title='终止任务'/></span>";
							trs += "&nbsp;";
							trs += "&nbsp;";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs += "</td>";
						}
					}
					
					if( type == "finished"){ // 最新任务，历史任务
						if(value.status == "stop" || value.status == "done" || value.status == "error"){
							trs += "<td><input type='checkbox' name='taskDeleteCheckbox' value='" + value.job_id + "' /></td>";
						}else{
							trs += "<td></td>";
						}
					}else{
						trs += "<td></td>";
					}
					
					trs += "</tr>";
				});
			}
			
			
			
			$("#task-" + type + "-list-tbody").append(trs);
			
			for(var i = 0; i < 10; i++){
				var s = "#status-" + i;
				//console.log(s);
				statusShow[i] = $(s).text(); 
			}
		}
		
		
	});
	
	clearInterval(statusTimer);
	statusTimer = setInterval("statusRequest()", 2000);
	
}

function showTaskList1(type){
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-" + type + "-list-form").show();
	
	var statusCode = 0;
	if(type == "running"){
		statusCode = 1;
	}else if(type == "finished"){
		statusCode = 2;
	}else if(type == "report" || type == "multiReport"){
		statusCode = 3;
	}else if(type == "latest"){
		// 全部
		statusCode = 4;
	}
	
	// 当前页面
	var pageValue = parseInt($("#task-" + type + "-current-page-span").text()) - 1;
	var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), status : statusCode , flag : encodeURI("1") };
	
	var st = $("#hidden-st-" + type).val();
	var ed = $("#hidden-ed-" + type).val();
	var numDay = $("#hidden-num-" + type).val();
	if(st != 0){
		paramsValue.st = st;
	}
	if(ed != 0){
		paramsValue.ed = ed;
	}
	if(numDay != 0){
		paramsValue.num = numDay;
	}
	
	/* //6666----------------------------------日期筛选start----------------------------------
	
	var now = new Date();
	var year = now.getFullYear(); 
	var month = now.getMonth() + 1;
    var date = now.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
	var edFormatDate = "";
	edFormatDate = year + month + date; 
	$("#ed-date-finished").val(edFormatDate);
	$("#ed-date-report").val(edFormatDate);
	$("#ed-date-multiReport").val(edFormatDate);
	$("#cycle-start-time").val(edFormatDate);			//这里的ed是筛选时间的结束，但却是测量周期的开始
	$("#single-cycle-start-time").val(edFormatDate);	//这里的ed是筛选时间的结束，但却是测量周期的开始
	
	$("#ed-date-local").val(edFormatDate);
	$("#ed-date-youku").val(edFormatDate);
	$("#ed-date-tudou").val(edFormatDate);
	$("#ed-date-letv").val(edFormatDate);
	$("#ed-date-qiyi").val(edFormatDate);
	$("#ed-date-sohu").val(edFormatDate);
	$("#ed-date-qq").val(edFormatDate);
	$("#ed-date-cntv").val(edFormatDate);
	$("#ed-date-brtn").val(edFormatDate);
	$("#ed-date-other").val(edFormatDate);
	 
	var lastNow = new Date(now);
	lastNow.setDate(lastNow.getDate() - 30); 
	var lastNow_forCycle = new Date(now);
	lastNow_forCycle.setDate(lastNow_forCycle.getDate() + 30);
	year = lastNow.getFullYear();
	month = lastNow.getMonth() + 1;
	month_forCycle = lastNow_forCycle.getMonth() + 1;
	date = lastNow.getDate();
	if (month < 10) month = "0" + month;
	if (month_forCycle < 10) month_forCycle = "0" + month_forCycle;
    if (date < 10) date = "0" + date;
	var stFormatDate = "";
	stFormatDate = year + month + date;
	var edFormatDate_forCycle = year + month_forCycle + date;
	$("#st-date-finished").val(stFormatDate);
	$("#st-date-report").val(stFormatDate);
	$("#st-date-multiReport").val(stFormatDate);
	$("#cycle-end-time").val(edFormatDate_forCycle);
	$("#single-cycle-end-time").val(edFormatDate_forCycle);
	
	$("#st-date-local").val(stFormatDate);
	$("#st-date-youku").val(stFormatDate);
	$("#st-date-tudou").val(stFormatDate);
	$("#st-date-letv").val(stFormatDate);
	$("#st-date-qiyi").val(stFormatDate);
	$("#st-date-sohu").val(stFormatDate);
	$("#st-date-qq").val(stFormatDate);
	$("#st-date-cntv").val(stFormatDate);
	$("#st-date-brtn").val(stFormatDate);
	$("#st-date-other").val(stFormatDate); 
	
	//----------------------------------日期筛选end---------------------------------------- */
	
	var videoListUrl = "/TaveenConsole/video/tasklist";
	$.get(videoListUrl, paramsValue, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		// 清空内容
		$("#task-" + type + "-list-tbody").empty();
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			// 设置总页面数，和当前页面值 666
			var totalPage = 0;
			if(jsonObj.ret_info.total_count % 10 == 0){
				totalPage = jsonObj.ret_info.total_count /10;
			}else{
				totalPage = Math.floor(jsonObj.ret_info.total_count / 10) + 1;
			}
			
			$("#task-" + type + "-total-count-span").text(totalPage);
			
			if(type == "report"){
				var multiNum = 0;
				$.each(jsonObj.ret_info.jobs, function(n,value) {
					var taskFlag = value.flag;
					if(taskFlag == "yes"){
						multiNum++;
					}
					var taskIndex = pageValue*10 + n + 1 - multiNum;
					//console.log("latest: pageVaule " + pageValue + ", n: " + n);
					//console.log(taskFlag);
					var node_name = value.node_name;
					if(taskFlag != "yes"){
						trs += "<tr><td>" + taskIndex + "</td><td>"
								//+ getNameString(value.name , 15) + "</td><td>"
								//+ getNameString(value.name) + "</td><td>"
								+ "<span title='" + getNameString(value.name) + "'>" + getNameString(value.name , 15) + "</span>" + "</td><td>"
							
								+ value.website + "</td><td class='address'>"
								+ "<a href='" + value.url +"' target='_blank' data-url=" + value.url + ">" + getUrlString(value.url , 45) + "</a>" 
								+ "<div>" + value.url + "</div></td><td>"
								+ node_name + "</div></td><td>";
						/* if(taskFlag == "yes"){
							var multi_job_id = value.autojob_id;
							trs += "<a data-toggle='modal' href='#multiInfoModal' onclick=\"showMultiInfoModal('" + multi_job_id + "')\">查看</a>"
						} */
						
						//trs += "</td><td>";
								
						if(value.st != "null" && value.st != null){
							trs += value.st	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						if(value.ed != "null" && value.ed != null){
							trs += value.ed	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						
						trs += changeToHanzi(value.status) + "</td>";
						
						//if(type == "report"){	 // 测量结果
							trs += "<td>";
							trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\" value='" + value.job_id + "' title='查看报告'/><span>";
							trs += "&nbsp;";
							trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							trs += "&nbsp;";
							trs += "</td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs += "</td>";
						//}
						trs += "</tr>";
					} //if flag != yes
					
				});
			}
			
			$("#task-" + type + "-list-tbody").append(trs);
		}
	});
	
}

function showTaskList2(type){
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-" + type + "-list-form").show();
	
	var statusCode = 0;
	if(type == "running"){
		statusCode = 1;
	}else if(type == "finished"){
		statusCode = 2;
	}else if(type == "report" || type == "multiReport"){
		statusCode = 3;
	}else if(type == "latest"){
		// 全部
		statusCode = 4;
	}
	
	//console.log(taskName)
	// 当前页面
	var pageValue = parseInt($("#task-" + type + "-current-page-span").text()) - 1;
	//var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), status : statusCode , flag : encodeURI("2")};
	var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), flag : encodeURI("2")};
	
	var st = $("#hidden-st-" + type).val();
	var ed = $("#hidden-ed-" + type).val();
	var numDay = $("#hidden-num-" + type).val();
	if(st != 0){
		paramsValue.st = st;
	}
	if(ed != 0){
		paramsValue.ed = ed;
	}
	if(numDay != 0){
		paramsValue.num = numDay;
	}
	
	/* //6666----------------------------------日期筛选start----------------------------------
	
	var now = new Date();
	var year = now.getFullYear(); 
	var month = now.getMonth() + 1;
    var date = now.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
	var edFormatDate = "";
	edFormatDate = year + month + date; 
	$("#ed-date-finished").val(edFormatDate);
	$("#ed-date-report").val(edFormatDate);
	$("#ed-date-multiReport").val(edFormatDate);
	$("#cycle-start-time").val(edFormatDate);			//这里的ed是筛选时间的结束，但却是测量周期的开始
	$("#single-cycle-start-time").val(edFormatDate);	//这里的ed是筛选时间的结束，但却是测量周期的开始
	
	$("#ed-date-local").val(edFormatDate);
	$("#ed-date-youku").val(edFormatDate);
	$("#ed-date-tudou").val(edFormatDate);
	$("#ed-date-letv").val(edFormatDate);
	$("#ed-date-qiyi").val(edFormatDate);
	$("#ed-date-sohu").val(edFormatDate);
	$("#ed-date-qq").val(edFormatDate);
	$("#ed-date-cntv").val(edFormatDate);
	$("#ed-date-brtn").val(edFormatDate);
	$("#ed-date-other").val(edFormatDate);
	 
	var lastNow = new Date(now);
	lastNow.setDate(lastNow.getDate() - 30); 
	var lastNow_forCycle = new Date(now);
	lastNow_forCycle.setDate(lastNow_forCycle.getDate() + 30);
	year = lastNow.getFullYear();
	month = lastNow.getMonth() + 1;
	month_forCycle = lastNow_forCycle.getMonth() + 1;
	date = lastNow.getDate();
	if (month < 10) month = "0" + month;
	if (month_forCycle < 10) month_forCycle = "0" + month_forCycle;
    if (date < 10) date = "0" + date;
	var stFormatDate = "";
	stFormatDate = year + month + date;
	var edFormatDate_forCycle = year + month_forCycle + date;
	$("#st-date-finished").val(stFormatDate);
	$("#st-date-report").val(stFormatDate);
	$("#st-date-multiReport").val(stFormatDate);
	$("#cycle-end-time").val(edFormatDate_forCycle);
	$("#single-cycle-end-time").val(edFormatDate_forCycle);
	
	$("#st-date-local").val(stFormatDate);
	$("#st-date-youku").val(stFormatDate);
	$("#st-date-tudou").val(stFormatDate);
	$("#st-date-letv").val(stFormatDate);
	$("#st-date-qiyi").val(stFormatDate);
	$("#st-date-sohu").val(stFormatDate);
	$("#st-date-qq").val(stFormatDate);
	$("#st-date-cntv").val(stFormatDate);
	$("#st-date-brtn").val(stFormatDate);
	$("#st-date-other").val(stFormatDate); 
	
	//----------------------------------日期筛选end---------------------------------------- */
	
	var videoListUrl = "/TaveenConsole/video/tasklist";
	$.get(videoListUrl, paramsValue, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		// 清空内容
		$("#task-" + type + "-list-tbody").empty();
		$("#nameFilter-multiReport-ul").empty();
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			// 设置总页面数，和当前页面值 666
			var totalPage = 0;
			if(jsonObj.ret_info.total_count % 10 == 0){
				totalPage = jsonObj.ret_info.total_count /10;
			}else{
				totalPage = Math.floor(jsonObj.ret_info.total_count / 10) + 1;
			}
			
			$("#task-" + type + "-total-count-span").text(totalPage);
			
			if(type == "multiReport"){
				var taskIndex = 0;
				$.each(jsonObj.ret_info.jobs, function(n,value) {
					var taskFlag = value.flag;
					var taskIndex = pageValue*10 + n + 1;// - multiNum;
					if(taskFlag == "yes"){
						//taskIndex++;
						var node_name = value.node_name;
						trs += "<tr><td>" + taskIndex + "</td><td>"
								//+ getNameString(value.name , 15) + "</td><td>"
								//+ getNameString(value.name) + "</td><td>"
								+ "<span title='" + getNameString(value.name) + "'>" + getNameString(value.name , 15) + "</span>" + "</td><td>"
								
								+ value.website + "</td><td class='address'>"
								+ "<a href='" + value.url +"' target='_blank' data-url=" + value.url + ">" + getUrlString(value.url , 45) + "</a>" 
								+ "<div>" + value.url + "</div></td><td>"
								+ node_name + "</div></td><td>";
							
							var multi_job_id = value.autojob_id;
							trs += "<a data-toggle='modal' href='#multiInfoModal' onclick=\"showMultiInfoModal('" + multi_job_id + "')\">查看</a>"
						
						    trs += "</td><td>";
								
						if(value.st != "null" && value.st != null){
							trs += value.st	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						if(value.ed != "null" && value.ed != null){
							trs += value.ed	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						
						if(value.status == "error"){
							trs += "<a href = '#' onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'>错误</a>";
						}else{
							trs += changeToHanzi(value.status) + "</td>";	
						}
						 
							/* trs += "<td>";
							trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\" value='" + value.job_id + "' title='查看报告'/><span>";
							trs += "&nbsp;";
							trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							trs += "&nbsp;";
							trs += "</td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							trs += "</td><td>";
							trs += "<input type='checkbox' name='taskDeleteCheckbox' value='" + value.job_id + "' />";
							trs += "</td>";  */
						if(value.status == "stop" || value.status == "done" || value.status == "error"){//需要任务查看和任务操作的地方
							trs += "<td>";
							if(value.status == "error"){
								//trs += "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale'  onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'/></span>";
							}else{
								trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看报告'/></span>";
								trs += "&nbsp;";
								trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							}
							trs += "&nbsp;";
							trs += "</td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs += "</td>";
						}else{//只需要任务操作 不需要任务查看的地方
							trs +="<td></td><td>";
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs +="</td>"
						}	
							
							trs += "</td><td>";
							trs += "<input type='checkbox' name='taskDeleteCheckbox' value='" + value.job_id + "' />";
							trs += "</td>"; 
							
							
						trs += "</tr>";
					} //if flag == yes
				});
				
				var trs1 = "";
				var allObj = jsonObj.ret_info.all;
				//console.log(allObj);
				for(var i = 0; i < allObj.length; i++){
					//console.log(allObj[i]);
					trs1 += "<li><a href='#'>" + allObj[i] + "</a></li>";
				} 
			}
			
			$("#task-" + type + "-list-tbody").append(trs);
			$("#nameFilter-multiReport-ul").append(trs1);
			//为下拉菜单每个li绑定
			trs1 += "<li><a href='#'>" + "全部" + "</a></li>";
			$("#nameFilter-multiReport-ul").children("li").bind('click',function(){
				//alert($(this).text());
				var selectedTaskName = $(this).text();
				$("#selected-task-button").html(selectedTaskName);
				
				var trs1 = "";
				var allObj = jsonObj.ret_info.all;
				trs1 += "<li><a href='#'>" + "全部" + "</a></li>";
				for(var i = 0; i < allObj.length; i++){
					//console.log(allObj[i]);
					trs1 += "<li><a href='#'>" + allObj[i] + "</a></li>";
				}
			});
			
		}
	});
	
}

function showFilterTaskList(type,taskName){
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-" + type + "-list-form").show();
	
	var statusCode = 0;
	if(type == "running"){
		statusCode = 1;
	}else if(type == "finished"){
		statusCode = 2;
	}else if(type == "report" || type == "multiReport"){
		statusCode = 3;
	}else if(type == "latest"){
		// 全部
		statusCode = 4;
	}
	
	//console.log(taskName);
	// 当前页面
	var pageValue = parseInt($("#task-" + type + "-current-page-span").text()) - 1;
	//var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), status : statusCode , flag : encodeURI("2"), taskname: encodeURI(taskName)};
	var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), flag : encodeURI("2"), taskname: encodeURI(taskName)};
	
	var st = $("#hidden-st-" + type).val();
	//console.log($("#hidden-st-" + type).val());
	var ed = $("#hidden-ed-" + type).val();
	var numDay = $("#hidden-num-" + type).val();
	if(st != 0){
		paramsValue.st = st;
	}
	if(ed != 0){
		paramsValue.ed = ed;
	}
	if(numDay != 0){
		paramsValue.num = numDay;
	}
	
	//6666----------------------------------日期筛选start----------------------------------
	/*  
	var now = new Date();
	var year = now.getFullYear(); 
	var month = now.getMonth() + 1;
    var date = now.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
	var edFormatDate = "";
	edFormatDate = year + month + date; 
	$("#ed-date-finished").val(edFormatDate);
	$("#ed-date-report").val(edFormatDate);
	$("#ed-date-multiReport").val(edFormatDate);
	$("#cycle-start-time").val(edFormatDate);			//这里的ed是筛选时间的结束，但却是测量周期的开始
	$("#single-cycle-start-time").val(edFormatDate);	//这里的ed是筛选时间的结束，但却是测量周期的开始
	
	$("#ed-date-local").val(edFormatDate);
	$("#ed-date-youku").val(edFormatDate);
	$("#ed-date-tudou").val(edFormatDate);
	$("#ed-date-letv").val(edFormatDate);
	$("#ed-date-qiyi").val(edFormatDate);
	$("#ed-date-sohu").val(edFormatDate);
	$("#ed-date-qq").val(edFormatDate);
	$("#ed-date-cntv").val(edFormatDate);
	$("#ed-date-brtn").val(edFormatDate);
	$("#ed-date-other").val(edFormatDate);
	 
	var lastNow = new Date(now);
	lastNow.setDate(lastNow.getDate() - 30); 
	var lastNow_forCycle = new Date(now);
	lastNow_forCycle.setDate(lastNow_forCycle.getDate() + 30);
	year = lastNow.getFullYear();
	month = lastNow.getMonth() + 1;
	month_forCycle = lastNow_forCycle.getMonth() + 1;
	date = lastNow.getDate();
	if (month < 10) month = "0" + month;
	if (month_forCycle < 10) month_forCycle = "0" + month_forCycle;
    if (date < 10) date = "0" + date;
	var stFormatDate = "";
	stFormatDate = year + month + date;
	var edFormatDate_forCycle = year + month_forCycle + date;
	$("#st-date-finished").val(stFormatDate);
	$("#st-date-report").val(stFormatDate);
	$("#st-date-multiReport").val(stFormatDate);
	$("#cycle-end-time").val(edFormatDate_forCycle);
	$("#single-cycle-end-time").val(edFormatDate_forCycle);
	
	$("#st-date-local").val(stFormatDate);
	$("#st-date-youku").val(stFormatDate);
	$("#st-date-tudou").val(stFormatDate);
	$("#st-date-letv").val(stFormatDate);
	$("#st-date-qiyi").val(stFormatDate);
	$("#st-date-sohu").val(stFormatDate);
	$("#st-date-qq").val(stFormatDate);
	$("#st-date-cntv").val(stFormatDate);
	$("#st-date-brtn").val(stFormatDate);
	$("#st-date-other").val(stFormatDate);  */
	
	//----------------------------------日期筛选end----------------------------------------
	
	var videoListUrl = "/TaveenConsole/video/tasklist";
	$.get(videoListUrl, paramsValue, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		// 清空内容
		$("#task-" + type + "-list-tbody").empty();
		$("#nameFilter-multiReport-ul").empty();
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			// 设置总页面数，和当前页面值 666
			var totalPage = 0;
			if(jsonObj.ret_info.total_count % 10 == 0){
				totalPage = jsonObj.ret_info.total_count /10;
			}else{
				totalPage = Math.floor(jsonObj.ret_info.total_count / 10) + 1;
			}
			
			$("#task-" + type + "-total-count-span").text(totalPage);
			
			if(type == "multiReport"){
				var taskIndex = 0;
				if(jsonObj.ret_info.jobs){
				$.each(jsonObj.ret_info.jobs, function(n,value) {
					var taskFlag = value.flag;
					if(taskFlag == "yes"){
						taskIndex++;
						var node_name = value.node_name;
						trs += "<tr><td>" + taskIndex + "</td><td>"
							+ "<span title='" + getNameString(value.name) + "'>" + getNameString(value.name , 15) + "</span>" + "</td><td>"
							
							+ value.website + "</td><td class='address'>"
							+ "<a href='" + value.url +"' target='_blank' data-url=" + value.url + ">" + getUrlString(value.url , 45) + "</a>" 
							+ "<div>" + value.url + "</div></td><td>"
							+ node_name + "</div></td><td>";
							
							var multi_job_id = value.autojob_id;
							trs += "<a data-toggle='modal' href='#multiInfoModal' onclick=\"showMultiInfoModal('" + multi_job_id + "')\">查看</a>";
						
						    trs += "</td><td>";
								
						if(value.st != "null" && value.st != null){
							trs += value.st	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						if(value.ed != "null" && value.ed != null){
							trs += value.ed	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						
						if(value.status == "error"){
							trs += "<a href = '#' onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'>错误</a>";							
						}else{
							trs += changeToHanzi(value.status) + "</td>";							
						}
						
						if(value.status == "done"){
							trs += "<td>";
							
							trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\" value='" + value.job_id + "' title='查看报告'/><span>";
							trs += "&nbsp;";
							trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							trs += "&nbsp;";
							
							trs += "</td><td>";
						}else{//value.status == "error"
							trs += "<td></td><td>"; 
						}
						
							/* trs += "<td>";
							
							trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\" value='" + value.job_id + "' title='查看报告'/><span>";
							trs += "&nbsp;";
							trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
							trs += "&nbsp;";
							
							trs += "</td><td>"; */
							
							trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
							
							trs += "</td><td>";
							
							trs += "<input type='checkbox' name='taskDeleteCheckbox' value='" + value.job_id + "' /></td>";
							
							//trs += "</td>";
						trs += "</tr>";
					} //if flag == yes
				});
				}
				
				var trs1 = "";
				var allObj = jsonObj.ret_info.all;
				//console.log(allObj);
				trs1 += "<li><a href='#'>" + "全部" + "</a></li>";
				for(var i = 0; i < allObj.length; i++){
					//console.log(allObj[i]);
					trs1 += "<li><a href='#'>" + allObj[i] + "</a></li>";
				}
			}
			
			$("#task-" + type + "-list-tbody").append(trs);
			$("#nameFilter-multiReport-ul").append(trs1);
			//为下拉菜单每个li绑定
			$("#nameFilter-multiReport-ul").children("li").bind('click',function(){
				//alert($(this).text());
				var selectedTaskName = $(this).text();
				$("#selected-task-button").html(selectedTaskName);
				
				var trs1 = "";
				var allObj = jsonObj.ret_info.all;
				trs1 += "<li><a href='#'>" + "全部" + "</a></li>";
				for(var i = 0; i < allObj.length; i++){
					//console.log(allObj[i]);
					trs1 += "<li><a href='#'>" + allObj[i] + "</a></li>";
				}
			});
			
		}
	});
	
}

//显示批量视频任务列表
function showMultiTaskList() {
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-multi-list-form").show();

	// 当前页面
	var pageValue = parseInt($("#task-multi-current-page-span").text());
	//var pageValue = parseInt($("#task-multi-current-page-span").text()) - 1;
	//console.log(pageValue);
	var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10")};
	
	/* var st = $("#hidden-st-multi").val();
	var ed = $("#hidden-ed-multi").val();
	if(st != 0){
		paramsValue.st = st;
	}
	if(ed != 0){
		paramsValue.ed = ed;
	} */
	
	
	var videoListUrl = "/TaveenConsole/video/multitasklist";
	//从服务器获取task-multi-list 222
	$.get(videoListUrl, paramsValue, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		// 清空内容
		$("#task-multi-list-tbody").empty();
		
		var jsonObj = $.parseJSON(data.result);
		
		var totalPage = 0; //总页数
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			if(jsonObj.ret_info.length != 0) {
				totalPage = jsonObj.ret_info[0].total_pages;
				$("#task-multi-total-count-span").text(totalPage);
				
			}
			$.each(jsonObj.ret_info, function(n,value) {
				//var flag = jsonObj.flag;
				var webs = ""; 
				/* $.each(value.websites.split(","), function(n,value) { //把视频网站名称英文改成中文
					webs += changeWebsiteToZh(value) + ","
				}) */
				for(var key in value.websites){
					//console.log(key);
					webs += changeWebsiteToZh(key) + "," //显示在列表里“测评网站”那列
				
				}
				webs = webs.substring(0,webs.length-1);
				//var taskIndex = n + 1;
				var taskIndex = pageValue*10 + n + 1 - 10;
				//console.log("multi: pageVaule " + pageValue + ", n: " + n);
				var showNode = "";
				var node_id;
				for(var key in value.node){
					if(key != "node_id"){
					showNode += value.node[key] + " ";
					}
					else 
						node_id = value.node[key];
				}
						trs += "<tr><td>" + taskIndex + "</td><td>"
						+ "<span title='" + getNameString(value.video_name) + "'>" + getNameString(value.video_name , 15) + "</span>" + "</td><td>"
						//+ value.video_name + "</td><td>"	
						+ webs + "</td><td>"
						+ showNode + "</td><td>"
						//+ value.video_num + " " + value.video_type + " " + value.video_len + " " + value.video_def + " " + value.video_day + " " + value.video_time + "</td><td>"
						+ value.create_time + "</td><td>";
						
						var stopTime  = value.stop_time;
						if(stopTime == null || stopTime == "") {
							trs +="暂无" + "</td><td id='" + value.autojob_id + "'>";
						} else {
							trs += stopTime + "</td><td id='" + value.autojob_id + "'>";
						}
						
						var status = value.status;
						if(status == "stop") { //停止状态 777
							trs += "停止" + "</td><td>" 
								//+ "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale' onclick=\"showMultiInfoModal('" + value.autojob_id + "')\" data-toggle='modal' data-target='#multiInfoModal' value='" + value.job_id + "'  title='任务信息'/></span>"
								+ "<a href='#' onclick=\"('" + value.autojob_id + "')\" data-toggle='modal' data-target='#multiInfoModal' value='" + value.job_id + "'  title='任务信息'>查看</span>"
								+ "</td><td>"
								//+ "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale' onclick=\"restartMultiTask('" + value.autojob_id + "')\" data-toggle='modal' data-target='#restartMultiTaskModal' value='" + value.job_id + "'  title='重新测量'></span>" 
								+ "</td><td>" 
								+ "<input type='checkbox' name='taskDeleteCheckbox' value='" + value.autojob_id + "' /></td>"
								+ "</td><td>";
						} else { //运行状态 777
							trs += "运行" + "</td><td>" 
							//+ "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale' onclick=\"showMultiInfoModal('" + value.autojob_id + "')\" data-toggle='modal' data-target='#multiInfoModal' value='" + value.job_id + "'  title='任务信息'/></span>"
							+ "<a href='#' onclick=\"showMultiInfoModal('" + value.autojob_id + "')\" data-toggle='modal' data-target='#multiInfoModal' value='" + value.job_id + "'  title='任务信息'>查看</span>"
							+ "</td><td>"
							//+ "<span class='image_change'><img data-src='../images/pause.png' src='../images/pause-2.png' class='img-scale'  title='暂停任务'/></span>"
							+ "<span class='image_change'><img data-src='../images/stop.png' src='../images/stop-2.png' class='img-scale' onclick=\"stopMultiTask('" + value.autojob_id + "',this)\" title='终止任务'/></span>" 
							//+ "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale' onclick=\"restartMultiTask('" + value.autojob_id + "')\" data-toggle='modal' data-target='#restartMultiTaskModal' value='" + value.job_id + "'  title='重新测量'></span>" 
							+ "</td><td>"
							//+ "<input type='checkbox' name='taskDeleteCheckbox' value='" + value.autojob_id + "' /></td>";
						}
						
				trs += "  </td></tr>";
				
				
				
			});	//the end of $.each(jsonObj.ret_info, function(n,value) 
			$("#task-multi-list-tbody").append(trs);
		}
	});
}


function showMultiLog(){
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-multi-log-list-form").show();
	
	$("#task-multi-log-list-tbody").empty();
	
	// 当前页面
	var pageValue = parseInt($("#task-multi-log-current-page-span").text()) - 1;
	//var paramsValue = {page : encodeURI(pageValue),count : encodeURI("10"), status : statusCode , flag : encodeURI("0") };
	var paramsValue = {page : encodeURI(pageValue)};
	
	var videoListUrl = "/TaveenConsole/video/loglist";
	$.get(videoListUrl, paramsValue, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}

		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			var totalCount = jsonObj.ret_info.total_count;
			
			// 设置总页面数，和当前页面值 666
			var totalPage = 0;
			if(jsonObj.ret_info.total_length % 15 == 0){
				totalPage = jsonObj.ret_info.total_length /15;
			}else{
				totalPage = Math.floor(jsonObj.ret_info.total_length / 15) + 1;
			}
			$("#task-multi-log-total-count-span").text(totalPage);
			
			//console.log(totalCount);
			//console.log(jsonObj.ret_info.logs);
			
			for(var i = 0; i < totalCount; i++){
				var obj = jsonObj.ret_info.logs[i];
				//console.log(obj.name);
				var tasks = jsonObj.ret_info.logs[i].tasks;
				//console.log(tasks);
				
				//计划名称
				trs += "<tr><td>" 
					+ "<span title='" + getNameString(obj.name) + "'>" + getNameString(obj.name , 15) + "</span>"
					+ "</td>"; 

				//计划起止日期
				trs += "<td>"
					+ obj.period
					+ "</td>";
				
				//计划信息列，需要autojob_id
				var multi_job_id = obj.autojob_id;
				trs += "<td>";
				trs += "<a data-toggle='modal' href='#multiInfoModal' onclick=\"showMultiInfoModal('" + multi_job_id + "')\">查看</a>";
				trs += "</td>";
					
				//实际执行日期和执行情况
				trs += "<td><table>";
				for(var j = 0; j < tasks.length; j++){
				
					trs += "<tr>";
					
					//实际执行日期
					trs += "<td>";
					//trs += "hello";
					trs += tasks[j].date;
					trs += "</td>";
					
					trs += "</tr>";
				}
				trs += "</table></td>";
				
				trs += "<td><table>";
				for(var j = 0; j < tasks.length; j++){
					
					trs += "<tr>";
					
					//实际执行情况-网站名称
					var web = tasks[j].web;
					for(var k = 0; k < web.length; k++){
						if(web[k].status == "error"){
							trs += "<td class='log_error'>" + web[k].website + "</td>";
						}else if(web[k].status == "done"){
							trs += "<td class='log_done'>" + web[k].website + "</td>";
						}
					}
					
					trs += "</tr>";
				}

				trs += "</table></td>";
				
				
			}
			
			$("#task-multi-log-list-tbody").append(trs);
		}
	});
}


function showNodeTaskList(node , num){
	//其他页面隐藏
	$(".taveen-func-form").hide();
	$("#task-" + node + "-list-form").show();
	
	// 当前页面
	var pageValue = parseInt($("#task-"+ node + "-current-page-span").text()) - 1;
	var videoListUrl = "/TaveenConsole/video/tasklist";
	
	var params = {page : encodeURI(pageValue),count : encodeURI("10")};
	if(num < 0){
		params.website = node;
	}else{
		params.agent = num;
	}
	
	var st = $("#hidden-st-" + node).val();
	var ed = $("#hidden-ed-" + node).val();
	var numDay = $("#hidden-num-" + node).val();
	if(st != 0){
		params.st = st;
	}
	if(ed != 0){
		params.ed = ed;
	}
	if(numDay != 0){
		params.num = numDay;
	}
	
	$.get(videoListUrl, params, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		// 清空内容
		$("#task-"+ node + "-list-tbody").empty();
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var trs = "";
			
			// 设置总页面数，和当前页面值
			//console.log(jsonObj.ret_info.total_count / 10);
			var totalPage = 0;
			if(jsonObj.ret_info.total_count % 10 == 0){
				totalPage = jsonObj.ret_info.total_count /10;
			}else{
				totalPage = Math.floor(jsonObj.ret_info.total_count / 10) + 1;
			}
			
			$("#task-"+ node + "-total-count-span").text(totalPage);
			$.each(jsonObj.ret_info.jobs, function(n,value) {
				
				if(num == 1){
					if(value.status != "pending" && value.status != "doing"){
						return;
					}
				}
				
				var taskIndex = pageValue*10 + n + 1;
				trs += "<tr><td>" + taskIndex + "</td><td>"
						//+ getNameString(value.name , 15) + "</td><td class='address'>"
						//+ getNameString(value.name)
						+ "<span title='" + getNameString(value.name) + "'>" + getNameString(value.name , 15) + "</span>"
						+ "</td><td class='address'>"
						+ "<a href='"+value.url +"' target='_blank'>" + getUrlString(value.url , 45) + "</a>"
						+ "<div>" + value.url + "</div></td><td>";
						
						if(value.st != "null" && value.st != null){
							trs += value.st	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						if(value.ed != "null" && value.ed != null){
							trs += value.ed	+ "</td><td>";
						}else{
							trs += "</td><td>";
						}
						
						if(value.status == "error"){
							trs += "<a href = '#' onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'>错误</a>";
						}else{
							trs += changeToHanzi(value.status) + "</td>";	
						}
						
				if(value.status == "stop" || value.status == "done" || value.status == "error"){
					trs += "<td>";
					if(value.status == "error"){
						//trs += "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale'  onclick=\"showErrorInfo('" + value.job_id + "')\" data-toggle='modal' data-target='#errorMsgModal' value='" + value.job_id + "' title='错误信息'/></span>";
					}else{
						trs += "<span class='image_change'><img data-src='../images/report.png' src='../images/report-2.png' class='img-scale' onclick=\"showVideoReport('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看报告'/></span>";
						trs += "&nbsp;";
						trs += "<span class='image_change'><img data-src='../images/curve.png' src='../images/curve-2.png' class='img-scale' onclick=\"showDataCurve('" + value.job_id + "')\"  value='" + value.job_id + "' title='查看数据'/></span>";
					}
					trs += "&nbsp;";
					trs += "</td><td>";
					trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
					
					trs += "</td>"
				}else{
					trs += "<td>";
					trs += "<span class='image_change'><img data-src='../images/status.png' src='../images/status-2.png' class='img-scale' onclick=\"showRunningDataReport('" + value.job_id + "')\" data-toggle='modal' data-target='#runningDataReportModal' value='" + value.job_id + "' alt='运行数据'/></span>";
					trs += "&nbsp;";
					trs += "</td><td>";
					trs += "<span class='image_change'><img data-src='../images/stop.png' src='../images/stop-2.png' class='img-scale' onclick=\"stopVideoTask('" + value.job_id + "' ,'" + node +"' , " + num +")\" alt='终止任务'/></span>";
					trs += "&nbsp;";
					trs += "<span class='image_change'><img data-src='../images/restart.png' src='../images/restart-2.png' class='img-scale'  onclick=\"restartTask('" + value.job_id + "')\" data-toggle='modal' data-target='#restartTaskModal' value='" + value.job_id + "' title='重新测量'/></span>";
					trs += "&nbsp;";
					trs += "</td>";
				}
				trs += "</tr>"					
			});
			$("#task-"+ node + "-list-tbody").append(trs);
		}
	});
}

$(document).ready(function() {
	
	$(".func-tab-div").click(function(){
		var ele = $(this).next(); //获取兄弟节点，即下拉的菜单部分,这个元素用来判断菜单的状态是展开还是收起
		//console.log(ele);
		if(ele.attr('class').indexOf('in') < 0){ //表示该菜单是收起的,单击则展开
			var spancaret = $(">a >span",this).eq(0);
			spancaret.css("borderWidth", "5px 5px 0");
		} else if(ele.attr('class').indexOf('in') > 0){//表示该菜单是展开的,单击则收起
			var spancaret = $(">a >span",this).eq(0);
			spancaret.css("borderWidth", "0 5px 6px");
		} 
	});

	
//6666----------------------------------日期筛选start----------------------------------
	
	var now = new Date();
	var year = now.getFullYear(); 
	var month = now.getMonth() + 1;
    var date = now.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
	var edFormatDate = "";
	edFormatDate = year + month + date; 
	$("#ed-date-finished").val(edFormatDate);
	$("#ed-date-report").val(edFormatDate);
	$("#ed-date-multiReport").val(edFormatDate);
	$("#cycle-start-time").val(edFormatDate);			//这里的ed是筛选时间的结束，但却是测量周期的开始
	$("#single-cycle-start-time").val(edFormatDate);	//这里的ed是筛选时间的结束，但却是测量周期的开始
	
	$("#ed-date-local").val(edFormatDate);
	$("#ed-date-youku").val(edFormatDate);
	$("#ed-date-tudou").val(edFormatDate);
	$("#ed-date-letv").val(edFormatDate);
	$("#ed-date-qiyi").val(edFormatDate);
	$("#ed-date-sohu").val(edFormatDate);
	$("#ed-date-qq").val(edFormatDate);
	$("#ed-date-cntv").val(edFormatDate);
	$("#ed-date-brtn").val(edFormatDate);
	$("#ed-date-other").val(edFormatDate);
	 
	var lastNow = new Date(now);
	lastNow.setDate(lastNow.getDate() - 30); 
	var lastNow_forCycle = new Date(now);
	lastNow_forCycle.setDate(lastNow_forCycle.getDate() + 30);
	year = lastNow.getFullYear();
	month = lastNow.getMonth() + 1;
	month_forCycle = lastNow_forCycle.getMonth() + 1;
	date = lastNow.getDate();
	if (month < 10) month = "0" + month;
	if (month_forCycle < 10) month_forCycle = "0" + month_forCycle;
    if (date < 10) date = "0" + date;
	var stFormatDate = "";
	stFormatDate = year + month + date;
	var edFormatDate_forCycle = year + month_forCycle + date;
	$("#st-date-finished").val(stFormatDate);
	$("#st-date-report").val(stFormatDate);
	$("#st-date-multiReport").val(stFormatDate);
	$("#cycle-end-time").val(edFormatDate_forCycle);
	$("#single-cycle-end-time").val(edFormatDate_forCycle);
	
	$("#st-date-local").val(stFormatDate);
	$("#st-date-youku").val(stFormatDate);
	$("#st-date-tudou").val(stFormatDate);
	$("#st-date-letv").val(stFormatDate);
	$("#st-date-qiyi").val(stFormatDate);
	$("#st-date-sohu").val(stFormatDate);
	$("#st-date-qq").val(stFormatDate);
	$("#st-date-cntv").val(stFormatDate);
	$("#st-date-brtn").val(stFormatDate);
	$("#st-date-other").val(stFormatDate); 
	
	//----------------------------------日期筛选end----------------------------------------
	
	
	$("#node-management").click(function(){
		window.location.href="/TaveenSetting/video/setting";
	});
	
	$("#user-management").click(function(){
		window.location.href="/TaveenSetting/video/user";
	});
	
    $("#data-management").click(function(){
		window.location.href="/TaveenSetting/video/data";
	});
    
    $("#data-delete").click(function(){
		window.location.href="/TaveenSetting/video/delete";
	});
    
	

	$("body").delegate(".address","mouseover",function(){
		$(this).children("div").show();
	});
	
	$("body").delegate(".address","mouseout",function(){
		$(this).children("div").hide();
	});

	$("body").delegate(".image_change","mouseover",function(){
		var img = $(this).children("img"),
			src = img.attr("src");
			data_src = img.data("src");
		img.attr("src", data_src);
		img.data("src", src);
	});
	
	$("body").delegate(".image_change","mouseout",function(){
		var img = $(this).children("img"),
			src = img.attr("src");
			data_src = img.data("src");
		img.attr("src", data_src);
		img.data("src", src);
	});
	

	// 重置
	$(".reset-button").click(function(){
		$("#video-name-text").val("");
		$("#video-url-text").val("");
		$("#video-keyword-text").val("");
		$('#video-site-div input[name="websiteCheckbox"]:checked ').each(function(){
			$(this).removeAttr("checked");
		});
		$('#video-type-div input[name="videoTypeCheckbox"]:checked ').each(function(){
			$(this).removeAttr("checked");
		});	
		$('#video-keyword-text').val("");
		$('#video-count-text').val("10");
		$('#video-list-tbody').empty();
	});
	
	//首先显示任务列表
	showTaskList("latest");
	
	//左列节点菜单展示 & get测评节点 for choose-node
	$.get("/TaveenConsole/video/createautodetail",function(data,status){
		$("#choose-node-form").empty();
		$("#single-choose-node-form").empty();
		var nodeListMenuStr = "";
		var jsonObj = $.parseJSON(data.result);
		if(jsonObj.ret_code == 0){
			var nodeStr = "";
			var node_name_ip = "";
			var jsonNode = jsonObj.ret_info.node;
			for(var i=0; i<jsonNode.length; i++){
				node_name_ip = jsonNode[i].node_name + " " + jsonNode[i].node_ip + '\r\n'; 
				var nodeID = jsonNode[i].node_id;
				if(i === 0){
					nodeStr += "<input type='radio' id=\"node-choose-" + i + "\" name='radioNodeChoose' checked='checked' value=\"" + nodeID + "\" />" + "<span class='margin-right-dist'>" + node_name_ip + "</span>" + '\r\n';
				}
				else{
					nodeStr += "<input type='radio' id=\"node-choose-" + i + "\" name='radioNodeChoose' value=\"" + nodeID + "\" />" + "<span class='margin-right-dist'>" + node_name_ip + "</span>" + '\r\n';
				}
				
				nodeListMenuStr += "<div id=\"node-list-menu-" + i + "\" class='func-list'>" + jsonNode[i].node_name + "</div>";
			}
		}
		//console.log(nodeListMenu);
		$("#choose-node-form").append(nodeStr);
		$("#single-choose-node-form").append(nodeStr);
		//$("#collapseThree").append(nodeListMenuStr); 
	});
	

	// 删除任务
	/* $("#delete-task-button-latest").click(function(){
		deleteTaskInJquery("latest");
	}); */
	$("#delete-task-button-finished").click(function(){
		deleteTaskInJquery("finished");
	});
	$("#delete-task-button-piliang").click(function(){
		deleteMultiTask("chuancan");
	});
	$("#delete-task-button-multi2").click(function(){
		deleteTaskInJquery2("finished");
	});
	
	function deleteTaskInJquery(type){
		var taskIds = [];
		$('input[name="taskDeleteCheckbox"]:checked ').each(function(){
			taskIds.push($(this).val());
		});
		if(taskIds.length <= 0){
			//alert("没有选择任何要删除的视频！");
			/* clearTimeout(timer);
            var timer = setTimeout(function () {alert("没有选择任何要删除的视频！");}, 1000)  */
            var d1 = dialog({
                title: '提示',
                content: '没有选择任何要删除的视频！',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
            
			return;
		}
		var d2 = dialog({
            title: '提示',
            content: '确认删除选中的任务吗？',
            width: 260,
            okValue: '确定',
            ok: function () {
            	deleteTask(taskIds , type , -2);            	
            },
            cancelValue: '取消',
            cancel: function () {}
        });
		if(d2.show("确认删除选中的任务吗？")){
			// -2表示最新任务什么的
			deleteTask(taskIds , type , -2);		
		}
        
		/* if(confirm("确认删除选中的任务吗？")){
			// -2表示最新任务什么的
			deleteTask(taskIds , type , -2);		
		} */
	}
	
	function deleteTaskInJquery2(type){
		var taskIds = [];
		$('input[name="taskDeleteCheckbox"]:checked ').each(function(){
			taskIds.push($(this).val());
		});
		if(taskIds.length <= 0){
			//alert("没有选择任何要删除的视频！");
			 var d1 = dialog({
                title: '提示',
                content: '没有选择任何要删除的视频！',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
			
			return;
		}
		var d2 = dialog({
            title: '提示',
            content: '确认删除选中的任务吗？',
            width: 260,
            okValue: '确定',
            ok: function () {
            	deleteTask(taskIds , type , -3);            	
            },
            cancelValue: '取消',
            cancel: function () {}
        });
		if(d2.show("确认删除选中的任务吗？")){
			// -2表示最新任务什么的
			deleteTask(taskIds , type , -3);		
		}
		
		/* if(confirm("确认删除选中的任务吗？")){
			// -2表示最新任务什么的
			deleteTask(taskIds , type , -3);		
		} */
	}
	
	// 新建单个测量任务页面：显示视频列表
	$("#create-single-task-button").click(function(){
		$("#single-step-2-div").hide();
		$("#single-step-1-div").show();
		$("#single-step-1-body-div").show();
		$("#single-step-2-body-div").hide();
		
		getSingleVideoList();
	});
	//筛选视频时显示视频列表
	$(".create-single-task-button").click(function(){
		$("#single-step-2-div").hide();
		$("#single-step-1-div").show();
		$("#single-step-1-body-div").show();
		$("#single-step-2-body-div").hide();
		
		getSingleVideoList();
	});
	
	// 新建测量任务页面：显示视频列表
	$(".create-task-button").click(function(){
		$("#step-2-div").hide();
		$("#step-1-div").show();
		$("#step-1-body-div").show();
		$("#step-2-body-div").hide();
		
		getVideoList();
	});
	
	// 新建多任务视频测量页面：显示视频列表
	$(".create-multi-task-button").click(function(){
		$("#step-2-div").hide();
		$("#step-1-div").show();
		$("#step-1-body-div").show();
		$("#step-2-body-div").hide();
		
	});
	
	// 新建本地测量任务页面：显示视频列表
	$(".create-local-task-button").click(function(){
		getLocalVideoList();
	});
	
	function getSingleVideoList(){
		var videoListUrl = "/TaveenConsole/video/videolist";
		
		var pageValue = $("#hidden-page-value-videolist").val();
		var countValue = $("#video-count-text").val();
		if(countValue == ""){
			countValue = 10;
		}
		
		var keywordValue = $("#video-keyword-text").val();
		
		var videoOrderValue = $('#video-order-div input[name="videoOrder"]:checked ').val();
		
		var websiteValue = "";
		$('#video-site-div input[name="websiteCheckbox"]:checked ').each(function(){
			websiteValue += $(this).val();
			websiteValue += ",";
		});
		
		var videoTypeValue = "";
		$('#video-type-div input[name="videoTypeCheckbox"]:checked ').each(function(){
			videoTypeValue += $(this).val();
			videoTypeValue += ",";
		});
		//新建任务界面
		$.get(videoListUrl,{page : encodeURI(pageValue), count : countValue , category:videoTypeValue, name : encodeURI(keywordValue), website : websiteValue, order : videoOrderValue}, function(data,status) {
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			// 清空内容
			$("#single-video-list-tbody").empty();
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				var trs = "";
				$.each(jsonObj.ret_info.videos, function(n,value) {
					trs += "<tr><td><button onclick=\"setSingleVideoSelected('" + value.name + "', '"+ value.url + "', '" + value.website + "', '"+ value.category + "')\" class='button button-primary button-rounded button-tiny' >选 择</button></td><td>"
							+ getNameString(value.name)
							+ "</td> <td>"
							+ value.category
							+ "</td> <td>"
							+ value.website
							//+ "</td> <td>"
							//+ getUrlString(value.url)
							+ "</td><td class='address'>"
							+ "<a href='" + value.url +"' target='_blank' data-url=" + value.url + ">" + getUrlString(value.url , 45) + "</a>" 
							+ "<div>" + value.url + "</div></td><td>"
							
							+ "</td></tr>";
				});
				$("#single-video-list-tbody").append(trs);
			}
		});
	}
	
	$("single-step-next-button").click(function(){
		$("#single-step-1-div").hide();
		$("#single-step-2-div").show();
		$("#single-step-1-body-div").hide();
		$("#single-step-2-body-div").show();
	});
	
	function getLocalVideoList(){
		var videoListUrl = "/TaveenConsole/video/videolist";
		
		$.get(videoListUrl,{website : 'local'}, function(data,status) {
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			// 清空内容
			$("#local-video-list-tbody").empty();
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				var trs = "";
				$.each(jsonObj.ret_info.videos, function(n,value) {
					trs += "<tr><td><button onclick=\"setLocalVideoSelected('" + value.name + "', '"+ value.url + "')\" class='button button-primary button-rounded button-tiny' >选 择</button></td><td>"
							+ getNameString(value.name , 20)
							+ "</td> <td>"
							+ getUrlString(value.url , 60)
							+ "</td></tr>";
				});
				$("#local-video-list-tbody").append(trs);
			}
		});
	}
	
	function getVideoList(){
		var videoListUrl = "/TaveenConsole/video/videolist";
		
		var pageValue = $("#hidden-page-value-videolist").val();
		var countValue = $("#video-count-text").val();
		if(countValue == ""){
			countValue = 10;
		}
		
		var keywordValue = $("#video-keyword-text").val();
		
		var videoOrderValue = $('#video-order-div input[name="videoOrder"]:checked ').val();
		
		var websiteValue = "";
		$('#video-site-div input[name="websiteCheckbox"]:checked ').each(function(){
			websiteValue += $(this).val();
			websiteValue += ",";
		}); 
		
		var videoTypeValue = "";
		$('#video-type-div input[name="videoTypeCheckbox"]:checked ').each(function(){
			videoTypeValue += $(this).val();
			videoTypeValue += ",";
		});
		//新建任务界面
		$.get(videoListUrl,{page : encodeURI(pageValue), count : countValue , category:videoTypeValue, name : encodeURI(keywordValue), website : websiteValue, order : videoOrderValue}, function(data,status) {
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			// 清空内容
			$("#video-list-tbody").empty();
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				var trs = "";
				$.each(jsonObj.ret_info.videos, function(n,value) {
					trs += "<tr><td><button onclick=\"setVideoSelected('" + value.name + "', '"+ value.url + "')\" class='button button-primary button-rounded button-tiny' >选 择</button></td><td>"
							+ getNameString(value.name)
							//+ "</td> <td>"
							//+ getUrlString(value.url)
							+ "</td><td class='address'>"
							+ "<a href='" + value.url +"' target='_blank' data-url=" + value.url + ">" + getUrlString(value.url , 45) + "</a>" 
							+ "<div>" + value.url + "</div></td><td>"
							
							
							+ "</td></tr>";
				});
				$("#video-list-tbody").append(trs);
			}
		});
	}	//the end of getVideoList() 
	
	// 最新任务中创建测量任务模态框的下一步按钮，获取视频清晰度
	$("#step-next-button").click(function(){
		$("#step-1-div").hide();
		$("#step-2-div").show();
		$("#step-1-body-div").hide();
		$("#step-2-body-div").show();
		
		// 清空内容
		$("#resolution-div").empty();
		$("#loading-img").show();
		
		var urlValue = $("#video-url-text").val();
		var videoTypeUrl = "/TaveenConsole/video/videotype";
		$.get(videoTypeUrl,{url : encodeURI(urlValue)}, function(data,status) {
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			$("#loading-img").hide();
			
/* 			<!-- <label class="margin-right-dist">清晰度：</label>
			<input type="radio" name="resolution" checked="checked" value="SD"><span class="margin-right-dist">SD</span>
			<input type="radio" name="resolution" value="HD"><span class="margin-right-dist">HD</span>
			<input type="radio" name="resolution" value="SuperHD"><span class="margin-right-dist">SuperHD</span> --> */
			
			var jsonObj = $.parseJSON(data.result);
			var content = "<table><tbody>";
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				var count = 0;
				$.each(jsonObj.ret_info, function(n,value) {
					//if(n % 2 == 0){
					if(n % 4 == 0){
						content += "<tr>";
						if(n == 0){
							content += "<td><label class='margin-right-dist'>分辨率：</label></td>";
						}else{
							content += "<td></td>";
						}
					}
					
					if(n == 0){
						content += "<td><input type='radio' name='resolution' checked='checked' value='"+ value + "'><span>"+ value + "&nbsp;</span></td>";
					}else{
						content += "<td><input type='radio' name='resolution' value='"+ value + "'><span>"+ value + "&nbsp;</span></td>";
					}
					//if(n % 2 == 1){
					if(n % 4 == 3){
						content += "</tr>";
					}
					count = n; 
					
				});
				
				/* if(count % 2 == 0){
					content += "<td></td></tr>";
				} */
				
				content += "</tr></tbody></table>";
				
				
				//下面添加节点
				$.get("/TaveenConsole/video/createautodetail",function(data,status){
					var nodeListMenuStr = "";
					var jsonObj = $.parseJSON(data.result);
					if(jsonObj.ret_code == 0){
						var nodeStr = "";
						var node_name_ip = "";
						var jsonNode = jsonObj.ret_info.node;
						$("#latest-choose-node-form").empty();
						for(var i=0; i<jsonNode.length; i++){
							node_name_ip = jsonNode[i].node_name + " " + jsonNode[i].node_ip + '\r\n'; 
							var nodeID = jsonNode[i].node_id;
							if(i === 0){
							nodeStr += "<input type='radio' id=\"latest-node-choose-" + i + "\" name='radioLatestNodeChoose' checked='checked' value=\"" + nodeID + "\" />" + "<span class='margin-right-dist'>" + node_name_ip + "</span>" + '\r\n';
							}
							else{
							nodeStr += "<input type='radio' id=\"latest-node-choose-" + i + "\" name='radioLatestNodeChoose' value=\"" + nodeID + "\" />" + "<span class='margin-right-dist'>" + node_name_ip + "</span>" + '\r\n';
							}
							
							nodeListMenuStr += "<div id=\"latest-node-list-menu-" + i + "\" class='func-list'>" + jsonNode[i].node_name + "</div>";
						}
					}
					//console.log(nodeListMenu);
					$("#latest-choose-node-form").append(nodeStr);
				});
				
				
				$("#resolution-div").append(content);
			}else{
				$("#loading-img").hide();
				//alert("视频不能测量！");
				var d = dialog({
	                title: '提示',
	                zIndex: 1050,
	                content: '视频不能测量！',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	            });
	            d.show(); 
			}
		});
	});	//the end of step-next-button click function
	
	// 创建测量任务
	$("#task-create-button").click(function(){
		createTask("");
	});
	
	//确认创建
	$("#single-video-button").click(function() {
		createSingleTask();
	});
	$("#multi-video-button").click(function() {
		createMultiTask();
	});
	$("#local-task-create-button").click(function(){
		createTask("local");
	});
	
	function createTask(videoType) {
		// 用户名
		var userName = $("#hidden-username").val();
		
		var postData = {};
		postData.action = "create";
		postData.username = userName;
		
		if(videoType == "local"){
			postData.website = "local";
		}
		
		postData.type = $('#resolution-div input[name="resolution"]:checked ').val();
		
		var jobArr = [];
		var job = {};
		job.name = $("#" + videoType + "video-name-text").val();
		job.url = $("#" + videoType + "video-url-text").val();
		if(job.name == "" || job.name == "视频名称"){
			//alert("请输入视频名称");
			var d1 = dialog({
	                title: '提示',
	                content: '请输入视频名称',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d1.show();
			return;
		}
		if(job.url == "" || job.url == "视频地址"){
			//alert("请输入视频地址");
			var d2 = dialog({
	                title: '提示',
	                content: '请输入视频地址',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d2.show();
			return;
		}
		jobArr.push(job);
		postData.jobs = jobArr;
		
		var node_id;
		postData.node_id = jQuery('input[type="radio"][name="radioLatestNodeChoose"]:checked').val();
		
		var strData = JSON.stringify(postData);
		
		var postUrl = "/TaveenConsole/video/createtask";
		$.post(postUrl , {data:encodeURI(strData)} , function(data , status){
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				//alert("创建任务成功!");
				var d1 = dialog({
	                title: '提示',
	                content: '创建任务成功!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d1.show();
				$("#createVideoModal").modal("hide");
				showTaskList("latest");
			}else{
				//alert("创建任务失败!\n" + jsonObj.ret_info);
				//console.log(typeof jsonObj.ret_info); //number
				var codestr = String(jsonObj.ret_info);
				
				/* $("#eCode").text(jsonObj.ret_info);
				$("#eMsg").text(changeErrorToZh(codestr)); */
				
				/* var d2 = dialog({
	                title: '创建任务失败!',
	                //content: "<div>错误码：" + jsonObj.ret_info + "</div>" + "<p>错误描述：" + changeErrorToZh(codestr) + "</p>",
	                content: document.getElementById('createFailure'),
	                //width: '100%',
	                //height:'100%',
	                okValue: '确定',
	                ok: function () {},
	            }); */ 
				
				var errorMsg = changeErrorToZh(codestr);
	     		$("#create-error-msg-div").html(errorMsg);
	     		
	     		var errorCode = "错误( 错误码： " + jsonObj.ret_info + " )";
	     		$("#create-error-msg-h3").text(errorCode);
	     		
				$("#createVideoModal").modal("hide");
	            //d2.show();
	            
	            $("#createErrorModal").modal("show");
			}
		});
	}
	
	//444
	//-------------------------------------确认创建    向服务器post新建计划的信息---------------------------------------------
	function createMultiTask() {
		// 用户名
		var userName = $("#hidden-username").val();
		
		var postData = {};
		postData.action = "create";
		postData.username = userName;
		
		var webName = [];
		var webURL = [];
		$("input[name='checkboxWebsite']:checked").each(function(){
			var index = $(this).val().indexOf("http");
			//console.log(index);
			webName.push($(this).val().substr(0,index-2));
			webURL.push($(this).val().substr(index));
		});
		
		/* console.log(webName);
		console.log(webURL); */
		var videoName = [];
		$("input[name='radioVideoName']:checked").each(function(){
			videoName.push($(this).val());
		});
		/* $("input[name='websiteCheckboxMulti']:checked").each(function(){
			website.push($(this).val());
		}); */
		
		var type = [];
		$("input[name='videoTypeRadioMulti']:checked").each(function(){
			type.push($(this).val());
		});
		var day = [];
		$("input[name='weekCheckboxMulti']:checked").each(function(){
			day.push($(this).val());
		});
		
		var node_id = "";
		
		postData.videoName = videoName.toString(); 
		postData.webName = webName.toString();
		postData.webURL = webURL.toString();
		
		postData.cycle_start = $("#cycle-start-time").val();
		postData.cycle_end = $("#cycle-end-time").val();
		
		//postData.websites = website.toString();
		postData.video_type= type.toString();
		//postData.video_num = $("#video-num-multi").val();
		//console.log(day);
		postData.video_day = day.toString();
		postData.video_time = $("#start-time-multi").val();
		if($('input[type="radio"][name="timeRadioMulti"]:checked').val() == null || jQuery('input[type="radio"][name="timeRadioMulti"]:checked').val() == "-1") {
			postData.video_len = "-1";
		} else {
			postData.video_len = 60 * parseInt(jQuery('input[type="radio"][name="timeRadioMulti"]:checked').val());
		}
		postData.video_def = jQuery('input[type="radio"][name="definitionCheckboxMulti"]:checked').val();
		postData.node_id = jQuery('input[type="radio"][name="radioNodeChoose"]:checked').val();
		
		/* if(postData.video_num == "" || postData.video_num == "个数"){
			alert("请输入选取个数");
			return;
		} */
		if(postData.video_time == ""){
			//alert("请输入开始测量时间");
			var d1 = dialog({
                title: '提示',
                content: '请输入开始测量时间',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
			return;
		}
		var strData = JSON.stringify(postData);
		var test = {data:encodeURI(strData)};
		
		var postUrl = "/TaveenConsole/video/createmultitask";
		$.post(postUrl , {data:encodeURI(strData)} , function(data , status){
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				//alert("创建批量任务成功!");
				var d1 = dialog({
                title: '提示',
                content: '创建批量任务成功!',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
            
				$("#createMultiVideoModal").modal("hide");
				showMultiTaskList();
			}else{
				//alert("创建批量任务失败!\n" + jsonObj.ret_info);
				var d2 = dialog({
	                title: '提示',
	                content: "创建批量任务失败!\n" + jsonObj.ret_info,
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d2.show();
			}
		});
	}//end of function createMultiTask()
	
	function createSingleTask() {
		// 用户名
		var userName = $("#hidden-username").val();
		
		var postData = {};
		postData.action = "create";
		postData.username = userName;
		
		//var webName = $("#single-video-website-text").val;//webName needs	~~
		//var webName = singleVideoSelectedWebname;
		//var type = $("#single-video-type-text").val;	//type needs	~~
		//var type = singleVideoSelectedType;
		
		//var videoName = $("#single-video-name-text").val;	//videoName needs	~~	!!!!
		//var webURL = $("#single-video-url-text").val;//webURL needs		~~	!!!!
		//var videoName = singleVideoSelectedName;
		//var webURL = singleVideoSelectedUrl;
		
		var videoName;
		if(singleVideoSelectedName){
			videoName = singleVideoSelectedName;
		}else{//若是不是选择的视频而是手动输入的视频
			videoName = $("#single-video-name-text").val();
		}
		var webURL;
		if(singleVideoSelectedUrl){
			webURL = singleVideoSelectedUrl;
		}else{//若是不是选择的视频而是手动输入的视频
			webURL = $("#single-video-url-text").val();
		}
		var type;
		if(singleVideoSelectedType){
			type = singleVideoSelectedType;
		}else{//若是不是选择的视频而是手动输入的视频
			type = "movie";
		}
		var webName;
		if(singleVideoSelectedWebname){
			webName = singleVideoSelectedWebname;
		}else{//若是不是选择的视频而是手动输入的视频
			webName = "local";
		}
		
		

		var day = [];	//noch
		$("input[name='weekCheckboxMulti']:checked").each(function(){
			day.push($(this).val());
		});
		
		var node_id = "";	//noch
		
		postData.webName = webName.toString();	
		//postData.videoName = videoName.toString(); 
		//postData.webURL = webURL.toString();
		postData.videoName = videoName;
		postData.webURL = webURL;
		
		postData.cycle_start = $("#single-cycle-start-time").val();	//noch
		postData.cycle_end = $("#single-cycle-end-time").val();	//noch
		
		postData.video_type= type.toString();
		postData.video_day = day.toString();
		postData.video_time = $("#single-start-time-multi").val();	//noch
		if($('input[type="radio"][name="timeRadioMulti"]:checked').val() == null || jQuery('input[type="radio"][name="timeRadioMulti"]:checked').val() == "-1") {
			postData.video_len = "-1";	
		} else {
			postData.video_len = 60 * parseInt(jQuery('input[type="radio"][name="timeRadioMulti"]:checked').val());	//noch
		}
		postData.video_def = jQuery('input[type="radio"][name="definitionCheckboxMulti"]:checked').val();	//noch
		postData.node_id = jQuery('input[type="radio"][name="radioNodeChoose"]:checked').val();	
		if(postData.video_time == ""){
			//alert("请输入开始测量时间");
			var d = dialog({
	                title: '提示',
	                content: '请输入开始测量时间',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		var strData = JSON.stringify(postData);
		var test = {data:encodeURI(strData)};
		
		var postUrl = "/TaveenConsole/video/createmultitask";
		$.post(postUrl , {data:encodeURI(strData)} , function(data , status){
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				//alert("创建批量任务成功!");
				var d1 = dialog({
	                title: '提示',
	                content: '创建批量任务成功!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d1.show();
				$("#createSingleVideoModal").modal("hide");
				showMultiTaskList();
			}else{
				//alert("创建批量任务失败!\n" + jsonObj.ret_info);
				var d2 = dialog({
	                title: '提示',
	                content: "创建批量任务失败!\n" + jsonObj.ret_info,
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d2.show();
			}
		});
	}//end of function createSingleTask()
	
	// 按天数筛选任务
	$("#day-1-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(1);
		showTaskList("latest");
	});
	$("#day-2-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(2);
		showTaskList("latest");
	});
	$("#day-3-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(3);
		showTaskList("latest");
	});
	$("#day-4-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(4);
		showTaskList("latest");
	});
	$("#day-5-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(5);
		showTaskList("latest");
	});
	$("#day-6-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(6);
		showTaskList("latest");
	});
	$("#day-7-button").click(function(){
		$("#task-latest-current-page-span").text(1);
		$("#hidden-num-latest").val(7);
		showTaskList("latest");
	});
	
	
	
	// 最新任务列表
	$("#task-latest-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		
		selectLeftPartFunc("latest");
		
		
		
	});
	
	function selectLeftPartFunc(type){
		$("#hidden-num-"+type).val(0);
		$("#hidden-st-"+type).val(0);
		$("#hidden-ed-"+type).val(0);
		if(type != "report" && type != "multiReport"){
			showTaskList(type);
		}
		else if(type == "report"){
			showTaskList1(type);
		} 
		else if(type == "multiReport"){
			showTaskList2(type);
		}
	}
	
	
	// 历史任务列表
	$("#task-finished-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		});
		
		selectLeftPartFunc("finished");
	});
	
	// 测量结果列表
	$("#task-report-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 

		selectLeftPartFunc("report");
	});
	$("#task-multiReport-list-func").click(function(){
		nameSelect = false;
		
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 

		selectLeftPartFunc("multiReport");
	});
	
	$("#task-multi-log-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 

		showMultiLog();
	});
	
	// 批量视频列表
	$("#task-multi-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 

		showMultiTaskList();
	});
	
	// 本地任务列表
	$("#task-local-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		});
		selectLeftPartFunc_Node("local", -1);
	});
	
	// 其他任务列表
	$("#task-other-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		});
		selectLeftPartFunc_Node("other", -1);
	});
	
	// 节点一任务列表
	$("#task-node1-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("node1" , 1);
	});
	
	// 节点二任务列表
	$("#task-node2-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("node2" , 2);
	});
	
	// youku任务列表
	$("#task-youku-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("youku" , -1);
	});
	
	// brtn任务列表
	$("#task-brtn-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("brtn" , -1);
	});
	
	// cntv任务列表
	$("#task-cntv-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("cntv" , -1);
	});
	
	// tudou任务列表
	$("#task-tudou-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("tudou" , -1);
	});
	
	$("#task-letv-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("letv" , -1);
	});
	
	$("#task-sohu-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("sohu" , -1);
	});
	
	$("#task-qiyi-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("qiyi" , -1);
	});
	
	$("#task-qq-list-func").click(function(){
		var that = $(this);
		that.addClass("func-list-link");
		$(".func-list").each(function() {
			if($(this).attr('id') != that.attr('id')) {
				$(this).removeClass("func-list-link");
			}
		}); 
		selectLeftPartFunc_Node("qq" , -1);
	});
	
	function selectLeftPartFunc_Node(type , num){
		$("#hidden-num-"+type).val(0);
		$("#hidden-st-"+type).val(0);
		$("#hidden-ed-"+type).val(0);
		showNodeTaskList(type , num);
	}
	
	// 筛选任务点击事件
	$(".select-task-by-date").click(function(){
		
		var type = $(this).attr("data-type");
		// 设置当前页为1
		$("#task-" + type + "-current-page-span").text(1);
		// 设置起止日期
		var startDate = $("#st-date-" + type).val();
		var endDate = $("#ed-date-" + type).val()
		if(startDate != "" && endDate != ""){
			$("#hidden-st-"+type).val(startDate);
			$("#hidden-ed-"+type).val(endDate);
		}
		
		if(type=="finished"){
			showTaskList(type);
		}else if(type=="report"){
			showTaskList1(type);
		}else{
			showNodeTaskList(type, -1);
		}
	});
	
	var nameSelect = false;
	
	$(".select-task-by-date-name").click(function(){
		
			nameSelect = true;
		
			var type = $(this).attr("data-type");
			// 设置当前页为1
			$("#task-" + type + "-current-page-span").text(1);
			// 设置起止日期
			var startDate = $("#st-date-" + type).val();
			var endDate = $("#ed-date-" + type).val()
			if(startDate != "" && endDate != ""){
				$("#hidden-st-"+type).val(startDate);
				$("#hidden-ed-"+type).val(endDate);
			}
			var taskName = $("#selected-task-button").html();
			showFilterTaskList(type,taskName);
			
			//console.log(nameSelect);
			
		}
		
	);
	
	//console.log(nameSelect);
	
	function nameDateFilter(){
		
		nameSelect = true;
		
		var type = $(".select-task-by-date-name").attr("data-type");
		
		if(nameSelect == false){
			// 设置当前页为1
			$("#task-" + type + "-current-page-span").text(1);
		}
		
		// 设置起止日期
		var startDate = $("#st-date-" + type).val();
		var endDate = $("#ed-date-" + type).val()
		if(startDate != "" && endDate != ""){
			$("#hidden-st-"+type).val(startDate);
			$("#hidden-ed-"+type).val(endDate);
		}
		var taskName = $("#selected-task-button").html();
		showFilterTaskList(type,taskName);
	}
	
//==========================页面跳转==================================//
//=======执行日志列表跳转 start=======//
	$("#next-page-task-multi-log").click(function(){
		nextPage("multi-log");
		showMultiLog();
	});
	$("#previous-page-task-multi-log").click(function(){
		previousPage("multi-log");
		showMultiLog();
	});
	$("#first-page-task-multi-log").click(function(){
		firstPage("multi-log");
		showMultiLog();
	});
	$("#last-page-task-multi-log").click(function(){
		lastPage("multi-log");
		showMultiLog();
	});
//=======执行日志列表跳转 end=========//




//=======最新任务列表跳转 start=======//
	$("#next-page-task-latest").click(function(){
		nextPage("latest");
		showTaskList("latest");
	});
	$("#previous-page-task-latest").click(function(){
		previousPage("latest");
		showTaskList("latest");
	});
	$("#first-page-task-latest").click(function(){
		firstPage("latest");
		showTaskList("latest");
	});
	$("#last-page-task-latest").click(function(){
		lastPage("latest");
		showTaskList("latest");
	});
//=======最新任务列表跳转 end=======//

//=======已结束任务列表跳转 start=======//
	$("#next-page-task-finished").click(function(){
		nextPage("finished");
		showTaskList("finished");
	});
	$("#previous-page-task-finished").click(function(){
		previousPage("finished");
		showTaskList("finished");
	});
	$("#first-page-task-finished").click(function(){
		firstPage("finished");
		showTaskList("finished");
	});
	$("#last-page-task-finished").click(function(){
		lastPage("finished");
		showTaskList("finished");
	});
//=======已结束任务列表跳转 end=======//

//=======视频测量任务-测量计划列表跳转 start=======//
	$("#next-page-task-report").click(function(){
		nextPage("report");
		showTaskList1("report");
	});
	$("#previous-page-task-report").click(function(){
		previousPage("report");
		showTaskList1("report");
	});
	$("#first-page-task-report").click(function(){
		firstPage("report");
		showTaskList1("report");
	});
	$("#last-page-task-report").click(function(){
		lastPage("report");
		showTaskList1("report");
	});
//=======视频测量任务-测量计划列表跳转 end=======//

//=======视频测量计划-测量计划列表跳转 start=======//
	$("#next-page-task-multiReport").click(function(){
		nextPage("multiReport");
		//showTaskList2("multiReport");
		if(nameSelect == false){
			showTaskList2("multiReport");			
		}else {
			nameDateFilter();	
		}
		
	});
	$("#previous-page-task-multiReport").click(function(){
		previousPage("multiReport");
		//showTaskList2("multiReport");
		if(nameSelect == false){
			showTaskList2("multiReport");			
		}else {
			nameDateFilter();	
		}
	});
	$("#first-page-task-multiReport").click(function(){
		firstPage("multiReport");
		//showTaskList2("multiReport");
		if(nameSelect == false){
			showTaskList2("multiReport");			
		}else {
			nameDateFilter();	
		}
	});
	$("#last-page-task-multiReport").click(function(){
		lastPage("multiReport");
		//showTaskList2("multiReport");
		if(nameSelect == false){
			showTaskList2("multiReport");			
		}else {
			nameDateFilter();
		}
	});
//=======视频测量计划-测量计划列表跳转 end=======//

//=======本地任务跳转 start=======//
	$("#next-page-task-local").click(function(){
		nextPage("local");
		showNodeTaskList("local", -1);
	});
	$("#previous-page-task-local").click(function(){
		previousPage("local");
		showNodeTaskList("local", -1);
	});
	$("#first-page-task-local").click(function(){
		firstPage("local");
		showNodeTaskList("local", -1);
	});
	$("#last-page-task-local").click(function(){
		lastPage("local");
		showNodeTaskList("local", -1);
	});
	
	$("#last-multi-task-local").click(function(){
		lastPage("multi");
		showMultiTaskList();
	});
//=======本地任务跳转 end=======//
	
//=======多任务处理========//
	$("#next-page-task-multi").click(function(){
		nextPage("multi");
		showMultiTaskList();
	});
	
	$("#previous-page-task-multi").click(function(){
		previousPage("multi");
		showMultiTaskList();
	});
	$("#first-page-task-multi").click(function(){
		firstPage("multi");
		showMultiTaskList();
	});
	$("#last-page-task-multi").click(function(){
		lastPage("multi");
		showMultiTaskList();
	});
	
	$("#last-multi-task-local").click(function(){
		lastPage("multi");
		showMultiTaskList();
	});
//=======多任务处理end======//

//=======website任务列表跳转 start=======//
	$("#next-page-task-youku").click(function(){
		nextPage("youku");
		showNodeTaskList("youku" , -1);
	});
	$("#previous-page-task-youku").click(function(){
		previousPage("youku");
		showNodeTaskList("youku" , -1);
	});
	$("#first-page-task-youku").click(function(){
		firstPage("youku");
		showNodeTaskList("youku" , -1);
	});
	$("#last-page-task-youku").click(function(){
		lastPage("youku");
		showNodeTaskList("youku" , -1);
	});
	
	
	$("#next-page-task-cntv").click(function(){
		nextPage("cntv");
		showNodeTaskList("cntv" , -1);
	});
	$("#previous-page-task-cntv").click(function(){
		previousPage("cntv");
		showNodeTaskList("cntv" , -1);
	});
	$("#first-page-task-cntv").click(function(){
		firstPage("cntv");
		showNodeTaskList("cntv" , -1);
	});
	$("#last-page-task-cntv").click(function(){
		lastPage("cntv");
		showNodeTaskList("cntv" , -1);
	});
	
	
	
	$("#next-page-task-brtn").click(function(){
		nextPage("brtn");
		showNodeTaskList("brtn" , -1);
	});
	$("#previous-page-task-brtn").click(function(){
		previousPage("brtn");
		showNodeTaskList("brtn" , -1);
	});
	$("#first-page-task-brtn").click(function(){
		firstPage("brtn");
		showNodeTaskList("brtn" , -1);
	});
	$("#last-page-task-brtn").click(function(){
		lastPage("brtn");
		showNodeTaskList("brtn" , -1);
	});
	
	
	
	
	$("#next-page-task-tudou").click(function(){
		nextPage("tudou");
		showNodeTaskList("tudou" , -1);
	});
	$("#previous-page-task-tudou").click(function(){
		previousPage("tudou");
		showNodeTaskList("tudou" , -1);
	});
	$("#first-page-task-tudou").click(function(){
		firstPage("tudou");
		showNodeTaskList("tudou" , -1);
	});
	$("#last-page-task-tudou").click(function(){
		lastPage("tudou");
		showNodeTaskList("tudou" , -1);
	});
	
	$("#next-page-task-letv").click(function(){
		nextPage("letv");
		showNodeTaskList("letv" , -1);
	});
	$("#previous-page-task-letv").click(function(){
		previousPage("letv");
		showNodeTaskList("letv" , -1);
	});
	$("#first-page-task-letv").click(function(){
		firstPage("letv");
		showNodeTaskList("letv" , -1);
	});
	$("#last-page-task-letv").click(function(){
		lastPage("letv");
		showNodeTaskList("letv" , -1);
	});
	
	$("#next-page-task-qiyi").click(function(){
		nextPage("qiyi");
		showNodeTaskList("qiyi" , -1);
	});
	$("#previous-page-task-qiyi").click(function(){
		previousPage("qiyi");
		showNodeTaskList("qiyi" , -1);
	});
	$("#first-page-task-qiyi").click(function(){
		firstPage("qiyi");
		showNodeTaskList("qiyi" , -1);
	});
	$("#last-page-task-qiyi").click(function(){
		lastPage("qiyi");
		showNodeTaskList("qiyi" , -1);
	});
	
	$("#next-page-task-sohu").click(function(){
		nextPage("sohu");
		showNodeTaskList("sohu" , -1);
	});
	$("#previous-page-task-sohu").click(function(){
		previousPage("sohu");
		showNodeTaskList("sohu" , -1);
	});
	$("#first-page-task-sohu").click(function(){
		firstPage("sohu");
		showNodeTaskList("sohu" , -1);
	});
	$("#last-page-task-sohu").click(function(){
		lastPage("sohu");
		showNodeTaskList("sohu" , -1);
	});
	
	$("#next-page-task-qq").click(function(){
		nextPage("qq");
		showNodeTaskList("qq" , -1);
	});
	$("#previous-page-task-qq").click(function(){
		previousPage("qq");
		showNodeTaskList("qq" , -1);
	});
	$("#first-page-task-qq").click(function(){
		firstPage("qq");
		showNodeTaskList("qq" , -1);
	});
	$("#last-page-task-qq").click(function(){
		lastPage("qq");
		showNodeTaskList("qq" , -1);
	});
	
	$("#next-page-task-other").click(function(){
		nextPage("other");
		showNodeTaskList("other" , -1);
	});
	$("#previous-page-task-other").click(function(){
		previousPage("other");
		showNodeTaskList("other" , -1);
	});
	$("#first-page-task-other").click(function(){
		firstPage("other");
		showNodeTaskList("other" , -1);
	});
	$("#last-page-task-other").click(function(){
		lastPage("other");
		showNodeTaskList("other" , -1);
	});
//=======website任务列表跳转 end=======//

//=======节点任务列表跳转 start=======//
	$("#next-page-task-node1").click(function(){
		nextPage("node1");
		showNodeTaskList("node1" , 1);

	});
	$("#next-page-task-node2").click(function(){
		nextPage("node2");
		showNodeTaskList("node2" , 2);
	});
	
	$("#previous-page-task-node1").click(function(){
		previousPage("node1");
		showNodeTaskList("node1" , 1);
	});
	$("#previous-page-task-node2").click(function(){
		previousPage("node2");
		showNodeTaskList("node2" , 2);
	});
	
	$("#first-page-task-node1").click(function(){
		firstPage("node1");
		showNodeTaskList("node1" , 1);
	});
	$("#first-page-task-node2").click(function(){
		firstPage("node2");
		showNodeTaskList("node2" , 2);
	});
	
	$("#last-page-task-node1").click(function(){
		lastPage("node1");
		showNodeTaskList("node1" , 1);
	});
	$("#last-page-task-node2").click(function(){
		lastPage("node2");
		showNodeTaskList("node2" , 2);
	});
//=======节点任务列表跳转 end=======//

	function nextPage(node,flag){
		//总页面数量
		var totalCount = parseInt($("#task-" + node + "-total-count-span").text());
		// 当前页面值
		var pageValue = parseInt($("#task-" + node + "-current-page-span").text());
		if(totalCount <= pageValue){
			//alert("已经到了最后一页！");
			var d = dialog({
	                title: '提示',
	                content: '已经到了最后一页！',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		$("#task-" + node + "-current-page-span").text(pageValue + 1);
	}
	
	function previousPage(node){
		// 当前页面值
		var pageValue = parseInt($("#task-" + node + "-current-page-span").text());
		if(pageValue == 1){
			//alert("这已经是第一页了！");
			var d = dialog({
	                title: '提示',
	                content: '这已经是第一页了！',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		$("#task-" + node + "-current-page-span").text(pageValue - 1);
	}
	
	function firstPage(node){
		// 当前页面值
		var pageValue = parseInt($("#task-"+node+"-current-page-span").text());
		if(pageValue == 1){
			//alert("这已经是第一页了！");
			var d = dialog({
	                title: '提示',
	                content: '这已经是第一页了！',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		$("#task-"+node+"-current-page-span").text(1);
	}
	
	function lastPage(node){
		//总页面数量
		var totalCount = parseInt($("#task-" + node + "-total-count-span").text());
		// 当前页面值
		var pageValue = parseInt($("#task-" + node + "-current-page-span").text());
		if(totalCount == pageValue){
			//alert("已经到了最后一页！");
			var d = dialog({
	                title: '提示',
	                content: '已经到了最后一页！',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		$("#task-" + node + "-current-page-span").text(totalCount);
	}
	
	//退出
	$("#logout-span").click(function(){
		var url = "/TaveenConsole/video/logout";
		$.get(url, {} , function(data,status) {
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
		});
	});
	
	//修改密码
	$("#change-pwd").click(function(){
		window.location.href="/TaveenConsole/video/changepwd";
	});
	
	//删除帐号
	$("#del-user").click(function(){
		var url = "/TaveenConsole/video/deluser";
		$.get(url, {} , function(data,status) {
			var result = JSON.parse(data.result).ret_code;
			if(result == "0"){
				//alert("删除帐号成功");
				var d = dialog({
	                title: '提示',
	                content: '删除帐号成功',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
				window.location.href="/TaveenConsole/video/login";
				return;
			}
		});
		
	});
	
	$("#video-web-measure").click(function(){
		//window.location.href="http://192.168.1.20:8080/TaveenVideoWeb/";
		// by hxy 
		$.post("/TaveenVideoWeb/video/login",
			{token:"videoWeb"},
			function(data,status) {
				var result = data.result;
				if(result == 0) {
				window.location.href="/TaveenVideoWeb/video/home";
				}
			})
	});
	
	$("#system-setting").click(function(){
		//window.location.href="http://192.168.1.20:8080/TaveenVideoWeb/";
		// by hxy 
		$.post("/TaveenSetting/video/login",
			{token:"videosetting"},
			function(data,status) {
				var result = data.result;
				if(result == 0) {
				window.location.href="/TaveenSetting/video/setting";
				}
			})
	});
	
	
	$("#user-help").click(function(){
		//window.location.href="http://192.168.1.20:8080/TaveenVideoWeb/";
		// by hxy 
		$.post("/UserHelp/help/login",
			{token:"videoWeb"},
			function(data,status) {
				var result = data.result;
				if(result == 0) {
				window.location.href="/UserHelp/help/home";
				}
			})
	});
	
	//777
	$("#restart-task-button").click(function(){
		var jobId = $("#hidden-restarttask-jobid").val();
		if(jobId == 0){
			//alert("程序有错误!");
			var d = dialog({
	                title: '提示',
	                content: '程序有错误!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		restartTaskSure(jobId);
	});
	
	$("#restart-multi-task-button").click(function(){
		var jobId = $("#hidden-restartmultitask-jobid").val();
		if(jobId == 0){
			//alert("程序有错误!");
			var d = dialog({
	                title: '提示',
	                content: '程序有错误!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			return;
		}
		restartMultiTaskSure(jobId);
	});
	
	//获取用户名
	$.get("/TaveenConsole/video/username",{}, function(data, status) {
		var retCode = data.ret_code;
		if(retCode == 0) {
			$("#user-name").html(data.result);
		} else {
			$("#user-name").html("无法获取用户名");
		}
	});
	
	//跳转到注册页面
	$("#user-register").click(function() {
		window.location.href="/TaveenConsole/video/register";
	});
}); // ready 结束

function setVideoSelected(videoName , videoUrl){
	$("#video-name-text").val(videoName);
	$("#video-url-text").val(videoUrl);
}

function setSingleVideoSelected(videoName , videoUrl , videoWebsite , videoType){
	$("#single-video-name-text").val(videoName);
	$("#single-video-url-text").val(videoUrl);
	singleVideoSelectedName = videoName;
	singleVideoSelectedUrl = videoUrl;
	//$("#single-video-website-text").val(videoWebsite);
	//$("#single-video-type-text").val(videoType);
	singleVideoSelectedWebname = videoWebsite;
	singleVideoSelectedType = videoType;
}

function setLocalVideoSelected(videoName , videoUrl){
	$("#localvideo-name-text").val(videoName);
	$("#localvideo-url-text").val(videoUrl);
}

function showVideoReport(jobId){
	window.open('showreport?taskId=' + jobId,'newwindow','height=400,width=1000,top=100px,left=200px,toolbar=no,menubar=no,scrollbars=yes,resizable=no,location=no,status=no'); 
}

function showDataCurve(jobId){
	window.open('showcurve?taskId=' + jobId,'newwindow','height=400,width=1000,top=100px,left=200px,toolbar=no,menubar=no,scrollbars=yes,resizable=no,location=no,status=no'); 
}
	//中间数据
	var interval;
	function showRunningDataReport(jobId){		//包括画图部分
		$("#duration-progress-div").hide();
		
		clearInterval(interval);
		$("#running-data-textarea").val("");
		interval = setInterval("getRunningData('" + jobId + "')", 2000);// 注意函数名没有引号和括弧！	每隔2000ms
		getRunningData(jobId);
		
		//echarts----------------------------------------------------------------------------------------------
		//共用的变量	
		var a = "";	//全局变量
		var app = {};
		var xdate = [];//获取ts for xdate
		
		//定义a_ b_ x_ y_
	    var b_frr = "";
	    var ydata_frr = [];//获取framerealrate for ydata_frr
		var dom_frr = document.getElementById("framerealrate-echart");
	    var myChart_frr = echarts.init(dom_frr);
	    option_frr = null;
	    
	    var b_netbuf = "";
	    var ydata_netbuf = [];//获取netbuf for ydata_netbuf
	    var dom_netbuf = document.getElementById("netbuf-echart");
	    var myChart_netbuf = echarts.init(dom_netbuf);
	    option_netbuf = null;
	    
	    var b_fs = "";
	    var ydata_fs = [];//获取frame_scores for ydata_fs
	    var dom_fs = document.getElementById("framescores-echart");
	    var myChart_fs = echarts.init(dom_fs);
	    option_fs = null;
	    
	    var b_gop = "";
	    var ydata_gop = [];//获取gop for ydata_gop
	    var dom_gop = document.getElementById("gop-echart");
	    var myChart_gop = echarts.init(dom_gop);
	    option_gop = null;
	    
	    var b_vbr = "";
	    var ydata_vbr = [];//获取videobr for ydata_vbr
	    var dom_vbr = document.getElementById("videobr-echart");
	    var myChart_vbr = echarts.init(dom_vbr);
	    option_vbr = null;
	    
	    var b_phs = "";
	    var ydata_phs = [];//获取phase for ydata_phs
	    var dom_phs = document.getElementById("phase-echart");
	    var myChart_phs = echarts.init(dom_phs);
	    option_phs = null;
	    
	    var b_vol = "";
	    var ydata_vol = [];//获取volume for ydata_vol
	    var dom_vol = document.getElementById("volume-echart");
	    var myChart_vol = echarts.init(dom_vol);
	    option_vol = null;
	    
	    var b_mR = "";
	    var ydata_mR = [];//获取muteR for ydata_mR
	    var dom_mR = document.getElementById("muteR-echart");
	    var myChart_mR = echarts.init(dom_mR);
	    option_mR = null;
	    
	    var b_mL = "";
	    var ydata_mL = [];//获取muteL for ydata_mL
	    var dom_mL = document.getElementById("muteL-echart");
	    var myChart_mL = echarts.init(dom_mL);
	    option_mL = null;
	    
	    var b_pR = "";
	    var ydata_pR = [];//获取peakR for ydata_pR
	    var dom_pR = document.getElementById("peakR-echart");
	    var myChart_pR = echarts.init(dom_pR);
	    option_pR = null;
	    
	    var b_pL = "";
	    var ydata_pL = [];//获取peakL for ydata_pL
	    var dom_pL = document.getElementById("peakL-echart");
	    var myChart_pL = echarts.init(dom_pL);
	    option_pL = null;
	    
	    var b_abr = "";
	    var ydata_abr = [];//获取audiobr for ydata_abr
	    var dom_abr = document.getElementById("audiobr-echart");
	    var myChart_abr = echarts.init(dom_abr);
	    option_abr = null;
	    
	    for (var i = 0; i < 20; i++) {
	        addData();
	    }
	   
	    
	    //定义option
	    //framerealrate option_frr~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_frr = {
    		title:{
    	        text: '帧率',
    	        x: 'center',
                y: 0
    	    },
    	    tooltip:{
    	    	trigger: 'item',
    	    	position: 'bottom',
    	    	alwaysShowContent: true,
    	    	padding: 5
    	    },
	        xAxis: {
	            type: 'category',
	            boundaryGap: false,
	            data: xdate
	        },
	        yAxis: {
	            type: 'value',
	            boundaryGap: ['20%', '20%'],
	            min: 0,
	            max: 40,
	            name: 'fps'
	        },
	        series: [
	            {
	            	name: 'framerealrate',
	            	//name: '帧率单位：fps',
	            	symbolSize: '5',
	                type:'scatter',
	                data: ydata_frr
	            }
	        ]
	    };
	    //framerealrate option_frr~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    
	    //netbuf option_netbuf~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_netbuf = {
	    		title:{
	    	        text: '视频流缓存',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		        	type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		        	/* axisLabel:{
		        		textStyle:{
		        			fontSize:6
		        		}
		        	}, */
		        	/* axisTick:{
		        		inside:true,
		        	}, */
		            boundaryGap: true,
		            min: 0,
		            max: 40000,
		            name: 'KB' 
		        },
		        series: [
		            {
		            	name: 'netbuf',
		            	//name: '视频流缓存单位：KB',
		            	symbolSize: '5',
		                type: 'scatter',
		                data: ydata_netbuf
		            }
		        ]
		    };
	  //netbuf option_netbuf~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //frame_scores option_fs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_fs = {
	    		title:{
	    	        text: '抽样帧评分',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: 0,
		            max: 5
		        },
		        series: [
		            {
		            	name: 'frame_scores',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_fs
		            }
		        ]
		    };
	  //frame_scores option_fs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //gop option_gop~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_gop = {
	    		title:{
	    	        text: '视频损伤评分',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: 0,
		            max: 5
		        },
		        series: [
		            {
		            	name: 'gop',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_gop
		            }
		        ]
		    };
	  //gop option_gop~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //videobr option_vbr~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_vbr = {
	    		title:{
	    	        text: '视频比特率',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            /* min: 0,
		            max: 600, */
		            name: 'kbps'
		        },
		        series: [
		            {
		            	name: 'videobr',
		            	//name:'视频比特率单位：kbps',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_vbr
		            }
		        ]
		    };
	  //videobr option_vbr~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //phase option_phs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_phs = {
	    		title:{
	    	        text: '音频相位',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: -1,
		            max: 1,
		            name: '同相'
		        },
		        series: [
		            {
		            	name: 'phase',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_phs
		            }
		        ]
		    };
	  //phase option_phs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //volume option_vol~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_vol = {
	    		title:{
	    	        text: '音频响度',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: -60,
		            max: 0,
		            name: 'LKFS '
		        },
		        series: [
		            {
		            	//name: 'volume',
		            	name: 'loudness',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_vol
		            }
		        ]
		    };
	  //volume option_vol~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //muteR option_mR~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_mR = {
	    		title:{
	    	        text: '右声道音频静音',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    /* legend: {
	    	        data:['muteR', 'muteL']
	    	    }, */
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: /* [
			        {
			            type: 'category',
			            boundaryGap: false,
			            data: xdate
			        },
			        {
			            type: 'category',
			            boundaryGap: false,
			            data: xdate
			        },
		        ], */
		        {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: /* [
		        {
		        	name: 'muteR',
		        	type: 'value',
		            boundaryGap: ['20%', '20%']
		        },
		        {
		        	name: 'muteL',
		        	type: 'value',
		            boundaryGap: ['20%', '20%']
		        }
		        ], */
		        {
		        	//name: 'muteR',
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: 0,
		            max: 1
		        },
		        series:/*  [
		            {
		                type:'scatter',
		                name: 'muteR',
		                data: ydata_mR
		            },
		            {
		                type:'scatter',
		                name: 'muteL',
		                data: ydata_mL
		            }
		        ] */
		        {
		        	type:'scatter',
		        	symbolSize: '5',
	                name: 'muteR',
	                data: ydata_mR
		        }
		    };
	  //muteR option_mR~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //muteL option_mL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_mL = {
	    		title:{
	    	        text: '左声道音频静音',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: 0,
		            max: 1
		        },
		        series: [
		            {
		            	name: 'muteL',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_mL
		            }
		        ]
		    };
	  //volume option_mL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  
	  //peakR option_pR~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  option_pR = {
	    		title:{
	    	        text: '右声道音频爆音',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: 0,
		            max: 1
		        },
		        series: [
		            {
		            	name: 'peakR',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_pR
		            }
		        ]
		    };
	  
	  
	  //peakL option_pL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  option_pL = {
	    		title:{
	    	        text: '左声道音频爆音',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            min: 0,
		            max: 1
		        },
		        series: [
		            {
		            	name: 'peakL',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_pL
		            }
		        ]
		    };
	  
	  //audiobr option_abr~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    option_abr = {
	    		title:{
	    	        text: '音频比特率',
	    	        x: 'center',
                    y: 0
	    	    },
	    	    tooltip:{
	    	    	trigger: 'item',
	    	    	position: 'bottom',
	    	    	alwaysShowContent: true,
	    	    	padding: 5
	    	    },
		        xAxis: {
		            type: 'category',
		            boundaryGap: false,
		            data: xdate
		        },
		        yAxis: {
		        	type: 'value',
		            boundaryGap: ['20%', '20%'],
		            /* min: 0,
		            max: 200, */
		            name: 'kbps'
		        },
		        series: [
		            {
		            	name: 'audiobr',
		            	symbolSize: '5',
		                type:'scatter',
		                data: ydata_abr
		            }
		        ]
		    };
	  //audiobr option_abr~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	   
	  //push shift
	    function addData(shift) {	//参数shift标志是否移动
	        xdate.push(a);
		    
	        ydata_frr.push(b_frr);
	        
	        ydata_netbuf.push(b_netbuf);
	        ydata_fs.push(b_fs);
	        ydata_gop.push(b_gop);
	        ydata_vbr.push(b_vbr);
	        ydata_phs.push(b_phs);
	        ydata_vol.push(b_vol);
	        ydata_mR.push(b_mR);
	        ydata_mL.push(b_mL);
	        ydata_pR.push(b_pR);
	        ydata_pL.push(b_pL);
	        ydata_abr.push(b_abr);
	        
	        if (shift) {
	            xdate.shift();
	            
	            ydata_frr.shift();
	            ydata_netbuf.shift();
	            ydata_fs.shift();
	            ydata_gop.shift();
	            ydata_vbr.shift();
	            ydata_phs.shift();
		        ydata_vol.shift();
		        ydata_mR.shift();
		        ydata_mL.shift();
		        ydata_pR.shift();
		        ydata_pL.shift();
		        ydata_abr.shift();
	        }
	    }	//the end of function addData()
		
	   
	    
	    //获取a_ b_
	    app.timeTicket = setInterval(function () {
	    	$.get("/TaveenConsole/video/runningdata", {taskId : jobId} , function(data,status){
			var jsonObj = $.parseJSON(data.result);
			if (jsonObj.ret_code == 0) {
				var a0 = jsonObj.ret_info.ts;
				a = a0.substr(11,8);
				
				b_frr = jsonObj.ret_info.scores.video.framerealrate;	//注意这里不能简写，应与json里的同名
				
				b_netbuf = jsonObj.ret_info.scores.video.netbuf;
				
			    
				b_fs = jsonObj.ret_info.scores.video.frame_scores;
				b_gop = jsonObj.ret_info.scores.video.gop;
				b_vbr = jsonObj.ret_info.scores.video.videobr;
				
				var audioObj = jsonObj.ret_info.scores.audio;
				
				b_phs = audioObj.phase;
				b_vol = audioObj.volume;
				/* if(audioObj.volume == 1){
					b_vol = "同相";
				}
				else{
					b_vol = "反相";
				} */
				b_abr = audioObj.audiobr;
				
				if(audioObj.mute.R == null || audioObj.mute.R.length == 0){
					//b_mR = "null";
					b_mR = 0;
				} else {
					b_mR = audioObj.mute.R[audioObj.mute.R.length-1];
				}
				
				if(audioObj.mute.L == null || audioObj.mute.L.length == 0){
					//b_mL = "null";
					b_mL = 0;
				} else {
					b_mL = audioObj.mute.L[audioObj.mute.L.length-1];
				}
				
				if(audioObj.peak.R == null || audioObj.peak.R.length == 0){
					//b_pR = "null";
					b_pR = 0;
				} else {
					b_pR = audioObj.peak.R[audioObj.peak.R.length-1];
				}
				
				if(audioObj.peak.L == null || audioObj.peak.L.length == 0){
					//b_pL = "null";
					b_pL = 0;
				} else {
					b_pL = audioObj.peak.L[audioObj.peak.R.length-1];
				}
				
			}
		});
	    	
	        addData(true);
	        
	        //各组myChart_
	        myChart_frr.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                //name:'帧率',
	                data: ydata_frr
	            }]
	        });
	        
	        myChart_netbuf.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_netbuf
	            }]
	        });
	        
	        myChart_fs.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_fs
	            }]
	        });
	        
	        myChart_gop.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_gop
	            }]
	        });
	        
	        myChart_vbr.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_vbr
	            }]
	        });
	        
	        myChart_phs.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_phs
	            }]
	        });
	        
	        myChart_vol.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_vol
	            }]
	        });
	        
	        //myChart_mute.setOption(option_mute);
	        
	        myChart_mR.setOption({
	        	xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_mR
	            }]
	        });
	        
	        myChart_mL.setOption({
	        	xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_mL
	            }]
	        });
	        
	        //myChart_peak.setOption(option_peak);
	        myChart_pR.setOption({
	        	xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_pR
	            }]
	        });
	        
	        myChart_pL.setOption({
	        	xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_pL
	            }]
	        });
	        
	        myChart_abr.setOption({
	            xAxis: {
	                data: xdate
	            },
	            series: [{
	                data: ydata_abr
	            }]
	        });
	        
	    }, 2000);	//每隔2s addData 描点	; the end of app.timeTicket function
	    ;
	    
	    
	    if (option_frr && typeof option_frr === "object" && option_netbuf && typeof option_netbuf === "object" 
	    	&& option_fs && typeof option_fs === "object" && option_gop && typeof option_gop === "object"
	    	&& option_vbr && typeof option_vbr === "object" && option_phs && typeof option_phs === "object" 
	    	&& option_vol && typeof option_vol === "object" && option_mR && typeof option_mR === "object"
	    	&& option_mL && typeof option_mL === "object" && option_mR && typeof option_mR === "object"
		    	&& option_mL && typeof option_mL === "object" && option_abr && typeof option_abr === "object") 
	    {
	        var startTime = +new Date();
	        
	        myChart_frr.setOption(option_frr, true);
	        myChart_netbuf.setOption(option_netbuf, true);
	        myChart_fs.setOption(option_fs, true);
	        myChart_gop.setOption(option_gop, true);
	        myChart_vbr.setOption(option_vbr, true);
	        myChart_phs.setOption(option_phs, true);
	        myChart_vol.setOption(option_vol, true);
	        myChart_mR.setOption(option_mR, true);
	        myChart_mL.setOption(option_mL, true);
	        myChart_pR.setOption(option_pR, true);
	        myChart_pL.setOption(option_pL, true);
	        myChart_abr.setOption(option_abr, true);
	        
	        
	        var endTime = +new Date();
	        var updateTime = endTime - startTime;
	        console.log("Time used:", updateTime);
	    }
	    
		  //the end of echarts--------------------------------------------------------------------------------------------
		  
	}	//function showRunningDataReport

function getRunningData(jobId){
	$("#pending-msg-div").html("");
	var url = "/TaveenConsole/video/runningdata";
	$.get(url,{taskId : jobId}, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		var jsonObj = $.parseJSON(data.result);
		
		var statusNow = jsonObj.ret_info.status;
		if(statusNow == "done"){
			//alert("任务已经完成！");
			var d = dialog({
	                title: '提示',
	                content: '任务已经完成!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			clearInterval(interval);
			//$("#runningDataModalLabel").hide();
			$("#runningDataReportModal").modal('hide');
			return;
		}
		
		if(statusNow == "pending"){
			$("#duration-progress-div").hide();
     		$("#pending-msg-div").show();
     		$("#pending-msg-div").html("正在准备测量...");
			return;
		}
		
		$("#duration-progress-div").show();
 		$("#pending-msg-div").hide();
		
 		
 		//获得实时数据
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var audioObj = jsonObj.ret_info.scores.audio;
			var videoObj = jsonObj.ret_info.scores.video;
			
			var runningData = $("#running-data-textarea").val();
			var lineData = jsonObj.ret_info.ts + "   " + videoObj.framerealrate +"   "+ videoObj.netbuf +"   "+ videoObj.gop +"   "+ videoObj.frame_scores +"   "+ videoObj.videobr;
			
			/* if(audioObj.phase == null || audioObj.phase.length == 0){
				lineData += "   " + "null";
			} else {
				lineData += "   " + audioObj.phase[audioObj.phase.length-1];
			}
			
			if(audioObj.volume == null || audioObj.volume.length == 0){
				lineData += "   " + "null";
			} else {
				lineData += "   " + audioObj.volume[audioObj.volume.length-1];
			} */
			
			lineData += "   " + audioObj.phase + "   " + audioObj.volume + "   " + audioObj.audiobr;
			
			if(audioObj.mute.R == null || audioObj.mute.R.length == 0){
				lineData += "   " + "null";
			} else {
				lineData += "   " + audioObj.mute.R[audioObj.mute.R.length-1];
			}
			
			if(audioObj.mute.L == null || audioObj.mute.L.length == 0){
				lineData += "   " + "null";
			} else {
				lineData += "   " + audioObj.mute.L[audioObj.mute.L.length-1];
			}
			
			if(audioObj.peak.R == null || audioObj.peak.R.length == 0){
				lineData += "   " + "null";
			} else {
				lineData += "   " + audioObj.peak.R[audioObj.peak.R.length-1];
			}
			
			if(audioObj.peak.L == null || audioObj.peak.L.length == 0){
				lineData += "   " + "null";
			} else {
				lineData += "   " + audioObj.peak.L[audioObj.peak.L.length-1];
			}
			
			
			
			$("#running-data-textarea").val(runningData + "\n" + lineData);
			
			$("#duration-progress-div").show();
			$("#section-label").text("第 " + jsonObj.ret_info.scores.current_section + "/" + jsonObj.ret_info.scores.section + "分片");
			$("#progress-span").text(jsonObj.ret_info.scores.progress);
			$("#duration-span").text(jsonObj.ret_info.scores.duration);
		}else{
			//alert("任务已经失败！");
			var d = dialog({
	                title: '提示',
	                content: '任务已经失败!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d.show();
			clearInterval(interval);
			$("#runningDataReportModal").modal("hide");
		}
	});
}
//终止任务
function stopVideoTask(taskId , listType , num){
	if(confirm("确认要终止任务吗？")){
		// 用户名
		var userName = $("#hidden-username").val();
		
		var postData = {};
		postData.action = "stop";
		postData.username = userName;
		
		var jobArr = [];
		jobArr.push(taskId);
		postData.jobs = jobArr;
		var strData = JSON.stringify(postData);
		var postUrl = "/TaveenConsole/video/canceltask";
		$.post(postUrl , {data:encodeURI(strData)} , function(data , status){
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				//alert("终止任务成功!");
				var d1 = dialog({
	                title: '提示',
	                content: '终止任务成功!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d1.show();
				// 刷新页面数据
				// -2 表示上面的最新任务什么的，-1表示优酷什么的，1,2表示节点一二
				if(num == -2){
					showTaskList(listType);
				}else{
					showNodeTaskList(listType , num);
				}
			}else{
				//alert("终止任务失败!");
				var d1 = dialog({
	                title: '提示',
	                content: '终止任务失败!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d1.show();
			}
		});
	}
}

function stopMultiTask(taskIds,tmp) {
	if(confirm("确认要终止任务吗？")){
		// 用户名
		var userName = $("#hidden-username").val();
		
		var getUrl = "/TaveenConsole/video/stopmulti" + "?taskId=" + taskIds;
		$.get(getUrl , function(data , status){
			var result = data.result;
			if(result == "0"){
				window.location.href="/TaveenConsole/video/login";
				return;
			}
			
			var jsonObj = $.parseJSON(data.result);
			// 0 标示数据正确
			if (jsonObj.ret_code == 0) {
				//alert("终止任务成功!");
				var d1 = dialog({
	                title: '提示',
	                content: '终止任务成功!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d1.show();
				//$("#" + taskIds).text("停止");
				//$(tmp.parentNode).parent().html("  ");//不显示
				showMultiTaskList();
			}else{
				//alert("终止任务失败!");
				var d2 = dialog({
	                title: '提示',
	                content: '终止任务失败!',
	                width: 260,
	                okValue: '确定',
	                ok: function () {},
	                /* cancelValue: '取消',
	                cancel: function () {} */
	            });
	            d2.show();
			}
		});
	}
}

//删除任务
function deleteTask(taskIds , listType , num){
	// 用户名
	var userName = $("#hidden-username").val();
	
	var postData = {};
	postData.action = "delete";
	postData.username = userName;
	
	//var jobArr = [];
	//jobArr.push(taskId);
	postData.jobs = taskIds;
	var strData = JSON.stringify(postData);
	var postUrl = "/TaveenConsole/video/canceltask";
	$.post(postUrl , {data:encodeURI(strData)} , function(data , status){
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			//alert("删除任务成功!");
			var d1 = dialog({
                title: '提示',
                content: '删除任务成功!',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
			// 刷新页面数据
			// -2 表示上面的最新任务什么的，-1表示优酷什么的，1,2表示节点一二
			if(num == -2){
				showTaskList(listType);
			}else if (num == -3){
				showTaskList2("multiReport");
			}
			else{
				showNodeTaskList(listType , num);
			}
		}else{
			//alert("删除任务失败!");
			var d2 = dialog({
                title: '提示',
                content: '删除任务失败!',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d2.show();
		}
	});
}

//删除批量视频
function deleteMultiTask(taskIds){
	var taskIds = [];
	$('input[name="taskDeleteCheckbox"]:checked ').each(function(){
		taskIds.push($(this).val());
	});
	if(taskIds.length <= 0){
		//alert("没有选择任何要删除的视频！");
		var d1 = dialog({
                title: '提示',
                content: '没有选择任何要删除的视频！',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
		return;
	}
	var d2 = dialog({
        title: '提示',
        content: '确认删除选中的任务吗？',
        width: 260,
        okValue: '确定',
        ok: function () {
        	// 用户名
    		var userName = $("#hidden-username").val();
    		
    		var getUrl = "/TaveenConsole/video/deletemulti" + "?autojobs=" + taskIds;
    		$.get(getUrl , function(data , status){
    			var result = data.result;
    			if(result == "0"){
    				window.location.href="/TaveenConsole/video/login";
    				return;
    			}
    			
    			var jsonObj = $.parseJSON(data.result);
    			// 0 标示数据正确
    			if (jsonObj.ret_code == 0) {
    				//alert("删除任务成功!");
    				var d3 = dialog({
                    title: '提示',
                    content: '删除任务成功!',
                    width: 260,
                    okValue: '确定',
                    ok: function () {},
                    /* cancelValue: '取消',
                    cancel: function () {} */
                });
                d3.show();
    				// 刷新页面数据
    				// -2 表示上面的最新任务什么的，-1表示优酷什么的，1,2表示节点一二
                    showMultiTaskList();
    			}else{
    				//alert("删除任务失败!");
    				var d4 = dialog({
    	                title: '提示',
    	                content: '删除任务失败!',
    	                width: 260,
    	                okValue: '确定',
    	                ok: function () {},
    	                /* cancelValue: '取消',
    	                cancel: function () {} */
    	            });
    	            d4.show();
    			}
    		});
        },
        cancelValue: '取消',
        cancel: function () {} 
    });
    d2.show(); 
	 
}

// 重新测量弹窗
function restartTask(jobId){
	// 设置ID值
	$("#hidden-restarttask-jobid").val(jobId);
	
	// 清空任务信息
	$("#task-info-div").empty();
	var url = "/TaveenConsole/video/restart";
	$.get(url,{taskId : jobId}, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var detailObj = jsonObj.ret_info.detail;
			/* "website":"letv",
            "username":"admin",
            "name":"道士下山(1)",
            "url":"http://www.letv.com/ptv/vplay/23207129.html",
            "type":"SuperHD",
            "parallel":1,
            "desc":"None" */
			var taskDetail = "";
			taskDetail += "<label style='width:80px'>视频网站:</label><span>" + detailObj.website + "</span><br>";
			taskDetail += "<label style='width:80px'>用户名:</label><span>" + detailObj.username + "</span><br>";
			taskDetail += "<label style='width:80px'>视频名称:</label><span>" + detailObj.name + "</span><br>";
			taskDetail += "<label style='width:80px'>视频地址:</label><span>" + detailObj.url + "</span><br>";
			taskDetail += "<label style='width:80px'>清晰度:</label><span>" + detailObj.type + "</span><br>";
			taskDetail += "<label style='width:80px'>parallel:</label><span>" + detailObj.parallel + "</span><br>";
			taskDetail += "<label style='width:80px'>视频描述:</label><span>" + detailObj.desc + "</span>";
			$("#task-info-div").append(taskDetail);
		}else{
			//alert("获取任务信息失败！");
			var d = dialog({
                title: '提示',
                content: '获取任务信息失败！',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d.show();
		}
	});
}

//批量视频重新测量弹窗 777
function restartMultiTask(jobId){
	// 设置ID值
	$("#hidden-restartmultitask-jobid").val(jobId);
	// 清空任务信息
	$("#task-multi-info-div").empty();
	//var url = "/TaveenConsole/video/restart";
	$.get("/TaveenConsole/video/multitaskdetail", {taskId : jobId} , function(data,status){
		var jsonObj = $.parseJSON(data.result);
		if (jsonObj.ret_code == 0) {
			var detailObj = jsonObj.ret_info;
			var taskDetail = "";
			/* taskDetail += "<label style='width:80px'>视频网站:</label><span>" + detailObj.website + "</span><br>"; 
			taskDetail += "<label style='width:80px'>视频地址:</label><span>" + detailObj.url + "</span><br>"; */
			taskDetail += "<label style='width:120px'>视频名称: </label><span>" + detailObj.video_name + "</span><br>";
			taskDetail += "<label style='width:120px'>清晰度: </label><span>" + detailObj.video_def + "</span><br>";
			var webs = ""; 
			for(var key in detailObj.websites){
				//console.log(jsonObj.ret_info.websites[key]);
				webs += changeWebsiteToZh(key) + ":" + detailObj.websites[key] + "\r\n";
			} 
			taskDetail += "<label style='width:120px'>包含网站: </label><span>" + webs + "</span><br>";	//这里的样式需要更改 换行显示
			taskDetail += "<label style='width:120px'>测试周期: </label><span>" + detailObj.start_time + "--" + detailObj.end_time + "</span><br>";
			taskDetail += "<label style='width:120px'>每周开始测量时间: </label><span>" + detailObj.video_day + "</span><br>";
			taskDetail += "<label style='width:120px'>每天开始测量时间: </label><span>" + detailObj.video_time + "</span><br>";
			
			$("#task-multi-info-div").append(taskDetail);
		}else{
			//alert("获取任务信息失败！");
			var d = dialog({
                title: '提示',
                content: '获取任务信息失败！',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d.show();
		}
	});
}


// 确认重新测量
function restartTaskSure(jobId){
	// 用户名
	var userName = $("#hidden-username").val();
	
	var postData = {};
	postData.action = "restart";
	postData.username = userName;
	postData.job_id = jobId;
	
	var strData = JSON.stringify(postData);
	var postUrl = "/TaveenConsole/video/createtask";
	$.post(postUrl , {data:encodeURI(strData)} , function(data , status){
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			//alert("重新测量成功!");
			var d1 = dialog({
                title: '提示',
                content: '重新测量成功!',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
			showTaskList("latest");
			$("#restartTaskModal").modal("hide");
		}else{
			//alert("重新测量失败!\n" + jsonObj.ret_info);
			var d2 = dialog({
                title: '提示',
                content: "重新测量失败!\n" + jsonObj.ret_info,
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d2.show();
		}
	});
}

//批量视频 确认重新测量 777
function restartMultiTaskSure(jobId){
	// 用户名
	var userName = $("#hidden-username").val();
	
	var taskId = jobId;
		
	var getUrl = "/TaveenConsole/video/restartmulti" + "?autojob_id=" + taskId;
	$.get(getUrl , function(data , status){
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			//alert("重新测量成功!");
			var d1 = dialog({
                title: '提示',
                content: '重新测量成功!',
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d1.show();
			showMultiTaskList();
			$("#restartMultiTaskModal").modal("hide");
		}else{
			//alert("重新测量失败!\n" + jsonObj.ret_info);
			var d2 = dialog({
                title: '提示',
                content: "重新测量失败!\n" + jsonObj.ret_info,
                width: 260,
                okValue: '确定',
                ok: function () {},
                /* cancelValue: '取消',
                cancel: function () {} */
            });
            d2.show();
		}
	});
}

function changeErrorToZh(errorCode){
	switch(errorCode) {
	case '101':
		return '视频源解析失败，无法取得后续分片地址';
		break;
	case '102':
		return '视频源无法播放，可能源地址错误';
		break;
	case '103':
		return '视频源解析失败，无法取得首个分片地址';
		break;
	case '104':
		return '任务中断，可能系统崩溃或非正常关机引起';
		break;
	case '201':
		return '视频源解析失败，无法获取视频流元数据';
		break;
	case '202':
		return '创建任务失败，无法连接测量节点，可能测量节点未启动';
		break;
	case '301':
		return '创建任务失败，无法连接任务调度模块';
		break;
	}
}

function showErrorInfo(jobId){
	$("#error-msg-h3").html("");
	$("#error-msg-div").html("");
	var url = "/TaveenConsole/video/videoreport";
	$.get(url, {taskId : jobId}, function(data,status) {
		var result = data.result;
		if(result == "0"){
			window.location.href="/TaveenConsole/video/login";
			return;
		}
		
		var jsonObj = $.parseJSON(data.result);
		// 0 标示数据正确
		if (jsonObj.ret_code == 0) {
			var errorMsg = changeErrorToZh(jsonObj.ret_info.general.ErrorInfo.ERROR);
     		$("#error-msg-div").html(errorMsg);
     		var errorCode = "错误( 错误码： " + jsonObj.ret_info.general.ErrorInfo.ERROR + " )";
     		$("#error-msg-h3").text(errorCode);
		}
	});
}

//111

function showMultiInfoModal(jobId){
	 $.get("/TaveenConsole/video/multitaskdetail", {taskId : jobId} , function(data,status){
		 //console.log(data);
		var jsonObj = $.parseJSON(data.result);
		if (jsonObj.ret_code == 0) {
			$("#video-name-input").val(jsonObj.ret_info.video_name);
			$("#video-def-input").val(jsonObj.ret_info.video_def);
			
			var webs = ""; //先清空
			//$("#included-web-input").val("");
			$("#included-web-input").empty();
			for(var key in jsonObj.ret_info.websites){
				/* webs += changeWebsiteToZh(key) + ":" 
				+ jsonObj.ret_info.websites[key]
				+ "\r\n"; */
				
				webs += "<tr><td>"
				+ changeWebsiteToZh(key)
				+ "</td><td class='address'>"
				+ "<a href='" + jsonObj.ret_info.websites[key] +"' target='_blank' data-url=" + jsonObj.ret_info.websites[key] + ">" + jsonObj.ret_info.websites[key] + "</a>" 
				+ "<div>" + jsonObj.ret_info.websites[key] + "</div></td><td>"

				+ "</td></tr>";
				
			} 
			//$("#included-web-input").val(webs);
			$("#included-web-input").append(webs);
			
			var testCycle = "";
			testCycle = jsonObj.ret_info.start_time + "--" + jsonObj.ret_info.end_time;
			$("#test-cycle-input").val(testCycle);
			
			//$("#test-week-input").val(jsonObj.ret_info.video_day);
			var weekdays = new Array();
			weekdays_en = jsonObj.ret_info.video_day.split(","); //把string split成一个数组
			/* 
			console.log(weekdays_en);	//["fri", "sat", "sun", "fri", "sat", "sun"]
			console.log(typeof weekdays_en);	//object
			console.log(weekdays_en instanceof Array);	//true
			console.log(jsonObj.ret_info.video_day);	//fri,sat,sun,fri,sat,sun
			console.log(typeof jsonObj.ret_info.video_day);	//string
			//console.log("weekdays_en.length = " + weekdays_en.length);
			 */
			
			var weekdayStr = "";
			for(var i = 0; i < weekdays_en.length; i++){
				if(i != weekdays_en.length - 1){
					weekdayStr += changeWeekdayToZh(weekdays_en[i]) + ",";
				}
				else{
					weekdayStr += changeWeekdayToZh(weekdays_en[i]);
				}
			}
			//console.log(weekdays_en);
			//console.log(weekdayStr);
			$("#test-week-input").val(weekdayStr);
			$("#test-day-input").val(jsonObj.ret_info.video_time);
		} 
	}); 
	//$("#video-name-input").val("test");
	//console.log(jobId);
}

//333
//var webs = [];
var webName = new Array();
var webNamep = new Array();
var webUrl = new Array();

function newJobGetInfo(){
	
	$.get("/TaveenConsole/video/createautodetail",function(data,status){
		//console.log(data);
		var jsonObj = $.parseJSON(data.result);
		if(jsonObj.ret_code == 0){
			//-----------------------------------默认显示----------------------------------------
			//视频列表单选框
				var jsonMovie = jsonObj.ret_info.movie;
				//var movieNameStr = "";
				var trs = "";
				//$("#video-name-form").empty(); //视频列表
				$("#piliang-video-list-tbody").empty();
				for(var i=0; i<jsonMovie.length; i++){	//对每一条jsonMovie[i]，即每部电影
					var j = 0;	//各个视频的不同视频网站编号
					//console.log("第 " + i + "个视频：");
					webName[i] = new Array();
					webNamep[i] = new Array();
					webUrl[i] = new Array();
					for(var key in jsonMovie[i]){ 	//对该视频的每一对key-value
						if(key != "video_name"){
							//webName[i][j] = changeWebsiteToZh(key) + ": " + jsonMovie[i][key] + "<br />";
							webNamep[i][j] = key + ": " + jsonMovie[i][key];
							webName[i][j] = changeWebsiteToZh(key);
							webUrl[i][j] = jsonMovie[i][key];
							j++;
						}
						else if(i == 0){
							var movieName = jsonMovie[i].video_name ;
							//movieNameStr += "<input type='radio' id=\"moviename" + i + "\" name='radioVideoName' value=\"" + movieName + "\"  />" + movieName + '\r\n';
							trs += "<tr><td><input type='radio' id=\"moviename" + i + "\" name='radioVideoName'  value=\"" + movieName + "\" checked='checked' /></td><td>"
							+ movieName
							+ "</td><td>"
							+ j + "个网站"
							+ "</td></tr>";
						}
						else{
							var movieName = jsonMovie[i].video_name ;
							trs += "<tr><td><input type='radio' id=\"moviename" + i + "\" name='radioVideoName'  value=\"" + movieName + "\" /></td><td>"
							+ movieName
							+ "</td><td>"
							+ j + "个网站"
							+ "</td></tr>";
						}
					}
				}
				//$("#video-name-form").append(movieNameStr);
				$("#piliang-video-list-tbody").append(trs);
				
				//根据视频列表单选框选中值在“包含网站”中显示   ！！！默认
				$("#piliang-included-web-tbody").empty();
				for(var i=0; i<webName[0].length; i++){	//i 对应于 某一视频的不同网站的编号
		    		var trs = "";
		    		if(i == 0){
		    			trs += "<tr><td><input type='checkbox' id=\"moviebtn" + 0 + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[0][i] + "\" /></td><td>"
		    		}
		    		else{
		    			trs += "<tr><td><input type='checkbox' id=\"moviebtn" + 0 + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[0][i] + "\" /></td><td>"
		    		}
		    		trs += webName[0][i]
					//+ "</td><td>"
					//+ webUrl[0][i]
					+ "</td><td class='address'>"
					+ "<a href='" + webUrl[0][i] +"' target='_blank' data-url=" + webUrl[0][i] + ">" + webUrl[0][i] + "</a>" 
					+ "<div>" + webUrl[0][i] + "</div></td><td>"
					
					+ "</td></tr>";
		    		$("#piliang-included-web-tbody").append(trs);
		    	} 
				
				//根据视频列表单选框选中值在“包含网站”中显示  ！！！点击
				$("input[type='radio'][name='radioVideoName']").mouseover(function(){
				    $("#" + this.id).click(function(){
				    	var sub = this.id.substr(9);	
				    	var subNum = parseInt(sub);	//subNum 对应于 视频的编号
				    	//$("#included-web-form").empty();
				    	$("#piliang-included-web-tbody").empty();
				    	//下面是添加按钮（用于选择视频网站）
				    	for(var i=0; i<webName[subNum].length; i++){	//i 对应于 某一视频的不同网站的编号
				    		/* var webBtn = "";
				    		webBtn += "<input type='checkbox' id=\"moviebtn" + subNum + "-" + i + "\" name='checkboxWebsite' value=\"" + webNamep[subNum][i] + "\" />" + webName[subNum][i] + '\r\n';
				    		$("#included-web-form").append(webBtn); */
				    		var trs = "";
				    		trs += "<tr><td><input type='checkbox' id=\"moviebtn" + subNum + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[subNum][i] + "\" /></td><td>"
							+ webName[subNum][i]
							//+ "</td><td>"
							//+ webUrl[subNum][i]
							+ "</td><td class='address'>"
							+ "<a href='" + webUrl[subNum][i] +"' target='_blank' data-url=" + webUrl[subNum][i] + ">" + getUrlString(webUrl[subNum][i] , 45) + "</a>" 
							+ "<div>" + webUrl[subNum][i] + "</div></td><td>"
							
							+ "</td></tr>";
				    		$("#piliang-included-web-tbody").append(trs);
				    	} 
				    });	//the end of radio click function
				  });	//the end of $("input[type='radio']").mouseover function
			
			
			//----------------------------------------movie---------------------------------------------
			$("#radio_movie").click(function(){
				//视频列表单选框
				var jsonMovie = jsonObj.ret_info.movie;
				//var movieNameStr = "";
				var trs = "";
				//$("#video-name-form").empty(); //视频列表
				$("#piliang-video-list-tbody").empty();
				for(var i=0; i<jsonMovie.length; i++){	//对每一条jsonMovie[i]，即每部电影
					var j = 0;	//各个视频的不同视频网站编号
					//console.log("第 " + i + "个视频：");
					webName[i] = new Array();
					webNamep[i] = new Array();
					webUrl[i] = new Array();
					for(var key in jsonMovie[i]){ 	//对该视频的每一对key-value
						if(key != "video_name"){
							//webName[i][j] = changeWebsiteToZh(key) + ": " + jsonMovie[i][key] + "<br />";
							webNamep[i][j] = key + ": " + jsonMovie[i][key];
							webName[i][j] = changeWebsiteToZh(key);
							webUrl[i][j] = jsonMovie[i][key];
							j++;
						}
						else{
							var movieName = jsonMovie[i].video_name ;
							//movieNameStr += "<input type='radio' id=\"moviename" + i + "\" name='radioVideoName' value=\"" + movieName + "\"  />" + movieName + '\r\n';
							trs += "<tr><td><input type='radio' id=\"moviename" + i + "\" name='radioVideoName'  value=\"" + movieName + "\"  /></td><td>"
							+ movieName
							+ "</td><td>"
							+ j + "个网站"
							+ "</td></tr>";
						}
					}
				}
				//$("#video-name-form").append(movieNameStr);
				$("#piliang-video-list-tbody").append(trs);
				
				//根据视频列表单选框选中值在“包含网站”中显示
				$("input[type='radio'][name='radioVideoName']").mouseover(function(){
				    $("#" + this.id).click(function(){
				    	var sub = this.id.substr(9);	
				    	var subNum = parseInt(sub);	//subNum 对应于 视频的编号
				    	//$("#included-web-form").empty();
				    	$("#piliang-included-web-tbody").empty();
				    	//下面是添加按钮（用于选择视频网站）
				    	for(var i=0; i<webName[subNum].length; i++){	//i 对应于 某一视频的不同网站的编号
				    		/* var webBtn = "";
				    		webBtn += "<input type='checkbox' id=\"moviebtn" + subNum + "-" + i + "\" name='checkboxWebsite' value=\"" + webNamep[subNum][i] + "\" />" + webName[subNum][i] + '\r\n';
				    		$("#included-web-form").append(webBtn); */
				    		var trs = "";
				    		trs += "<tr><td><input type='checkbox' id=\"moviebtn" + subNum + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[subNum][i] + "\" /></td><td>"
							+ webName[subNum][i]
							//+ "</td><td>"
							//+ webUrl[subNum][i]
							+ "</td><td class='address'>"
							+ "<a href='" + webUrl[subNum][i] +"' target='_blank' data-url=" + webUrl[subNum][i] + ">" + webUrl[subNum][i] + "</a>" 
							+ "<div>" + webUrl[subNum][i] + "</div></td><td>"
							
							+ "</td></tr>";
				    		$("#piliang-included-web-tbody").append(trs);
				    	} 
				    });	//the end of radio click function
				  });	//the end of $("input[type='radio']").mouseover function
				
			});	// the end of radio_movie click function	
			
			//----------------------------------------tv---------------------------------------------
			$("#radio_tv").click(function(){
				//视频列表单选框
				var jsonTV = jsonObj.ret_info.tv;
				//var TVNameStr = ""; //for video-name-form
				var trs = ""; //for piliang-video-list-tbody
				//$("#video-name-form").empty(); //视频列表 // for form
				$("#piliang-video-list-tbody").empty();
				for(var i=0; i<jsonTV.length; i++){	//对每一条jsonTV[i]，即每个视频
					var j = 0;	//各个视频的不同视频网站编号
					//console.log("第 " + i + "个视频：");
					webName[i] = new Array();
					webNamep[i] = new Array(); //后面radio input的value传值会用到
					webUrl[i] = new Array();
					for(var key in jsonTV[i]){ 	//对该视频的每一对key-value
						if(key != "video_name"){
							//webName[i][j] = changeWebsiteToZh(key) + ": " + jsonTV[i][key] + "<br />";
							webNamep[i][j] = key + ": " + jsonTV[i][key];
							webName[i][j] = changeWebsiteToZh(key);
							webUrl[i][j] = jsonTV[i][key];
							j++;
						}
						else{
							var TVName = jsonTV[i].video_name ;
							//for video-name-form
							/* TVNameStr += "<input type='radio' id=\"tvname" + i + "\" name='radioVideoName' checked=\"checked\" value=\"" + TVName + "\" />" 
							+ TVName + "&nbsp\t " + j + "个网站" + "<br />" + '\r\n'; */ 
							
							//trs += "<tr><td><button onclick=\"setVideoSelected('" + value.name + "', '"+ value.url + "')\" class='button button-primary button-rounded button-tiny' >选 择</button></td><td>"
							trs += "<tr><td><input type='radio' id=\"tvname" + i + "\" name='radioVideoName' checked=\"checked\" value=\"" + TVName + "\" /></td><td>"
							+ TVName
							+ "</td> <td>"
							+ j + "个网站"
							+ "</td></tr>";
						}
					//console.log("webName: " +  webName);
					//console.log("webUrl: " + webUrl);
					}
					
				}
				//for video-name-form
				/* $("#video-name-form").append(TVNameStr); */
				//for piliang-video-list-tbody
				$("#piliang-video-list-tbody").append(trs);	
				
				//根据“视频列表”单选框选中值在“包含网站”中显示
				$("input[type='radio'][name='radioVideoName']").mouseover(function(){
				    $("#" + this.id).click(function(){
				    	var sub = this.id.substr(6);	//TVNameStr的按钮id的子字符串   ！！注意要随着id改变而改变！！！
				    	var subNum = parseInt(sub);	//subNum 对应于 视频的编号
				    	//$("#included-web-form").empty(); //for form
				    	$("#piliang-included-web-tbody").empty();
				    	var trs = "";
				    	//下面是添加按钮（用于选择视频网站）
				    	//console.log(webName[subNum]);
				    	for(var i=0; i<webName[subNum].length; i++){	//i 对应于 某一视频的不同网站的编号
				    		//for form
				    		/* var webBtn = "";
				    		webBtn += "<input type='checkbox' id=\"tvbtn" + subNum + "-" + i + "\" name='checkboxWebsite' value=\"" + webNamep[subNum][i] + "\" />" + webName[subNum][i] + '\r\n';
				    		$("#included-web-form").append(webBtn);  */
				    		//for tbody
				    		trs += "<tr><td><input type='checkbox' id=\"tvbtn" + subNum + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[subNum][i] + "\" /></td><td>"
							+ webName[subNum][i]
							//+ "</td> <td>"
							//+ webUrl[subNum][i]
							+ "</td><td class='address'>"
							+ "<a href='" + webUrl[subNum][i] +"' target='_blank' data-url=" + webUrl[subNum][i] + ">" + webUrl[subNum][i] + "</a>" 
							+ "<div>" + webUrl[subNum][i] + "</div></td><td>"
							
							+ "</td></tr>";
				    		
				    	} 
				    	$("#piliang-included-web-tbody").append(trs);
				    });	//the end of radio click function
				  });	//the end of $("input[type='radio']").mouseover function
				
			});	// the end of radio_tv click function
			
			//----------------------------------------tv_show---------------------------------------------
			$("#radio_tv_show").click(function(){
				//视频列表单选框
				var jsonShow = jsonObj.ret_info.tv_show;
				//var showNameStr = "";
				var trs = "";
				//$("#video-name-form").empty(); //视频列表
				$("#piliang-video-list-tbody").empty();
				for(var i=0; i<jsonShow.length; i++){	//对每一条jsonShow[i]
					var j = 0;	//各个视频的不同视频网站编号
					//console.log("第 " + i + "个视频：");
					webName[i] = new Array();
					webNamep[i] = new Array();
					webUrl[i] = new Array();
					for(var key in jsonShow[i]){ 	//对该视频的每一对key-value
						if(key != "video_name"){
							//webName[i][j] = changeWebsiteToZh(key) + ": " + jsonShow[i][key] + "<br />";
							webNamep[i][j] = key + ": " + jsonShow[i][key];
							webName[i][j] = changeWebsiteToZh(key);
							webUrl[i][j] = jsonShow[i][key];
							j++;
						}
						else{
							var showName = jsonShow[i].video_name ;
							//showNameStr += "<input type='radio' id=\"showname" + i + "\" name='radioVideoName' value=\"" + showName + "\" />" + showName + '\r\n';
							trs += "<tr><td><input type='radio' id=\"showname" + i + "\" name='radioVideoName' value=\"" + showName + "\" /></td><td>"
							+ showName
							+ "</td><td>"
							+ j + "个网站"
							+ "</td></tr>";
						}
					}
				}
				//$("#video-name-form").append(showNameStr);
				$("#piliang-video-list-tbody").append(trs);
				
				//根据视频列表单选框选中值在“包含网站”中显示
				$("input[type='radio'][name='radioVideoName']").mouseover(function(){
				    $("#" + this.id).click(function(){
				    	var sub = this.id.substr(8);	
				    	var subNum = parseInt(sub);	//subNum 对应于 视频的编号
				    	//$("#included-web-form").empty();
				    	$("#piliang-included-web-tbody").empty();
				    	//下面是添加按钮（用于选择视频网站）
				    	for(var i=0; i<webName[subNum].length; i++){	//i 对应于 某一视频的不同网站的编号
				    		/* var webBtn = "";
				    		webBtn += "<input type='checkbox' id=\"showbtn" + subNum + "-" + i + "\" name='checkboxWebsite' value=\"" + webNamep[subNum][i] + "\" />" + webName[subNum][i] + '\r\n';
				    		$("#included-web-form").append(webBtn); */
				    		var trs = "";
				    		trs += "<tr><td><input type='checkbox' id=\"showbtn" + subNum + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[subNum][i] + "\" /></td><td>"
							+ webName[subNum][i]
							//+ "</td><td>"
							//+ webUrl[subNum][i]
							+ "</td><td class='address'>"
							+ "<a href='" + webUrl[subNum][i] +"' target='_blank' data-url=" + webUrl[subNum][i] + ">" + webUrl[subNum][i] + "</a>" 
							+ "<div>" + webUrl[subNum][i] + "</div></td><td>"
							
							+ "</td></tr>";
				    		$("#piliang-included-web-tbody").append(trs);
				    	} 
				    });	//the end of radio click function
				  });	//the end of $("input[type='radio']").mouseover function
				
			});	// the end of radio_show click function
			
			//----------------------------------------animation---------------------------------------------
			$("#radio_animation").click(function(){
				//视频列表单选框
				var jsonAnimation = jsonObj.ret_info.animation;
				//var animationNameStr = "";
				var trs = "";
				//$("#video-name-form").empty(); //视频列表
				$("#piliang-video-list-tbody").empty();
				for(var i=0; i<jsonAnimation.length; i++){	//对每一条jsonMovie[i]，即每部电影
					var j = 0;	//各个视频的不同视频网站编号
					//console.log("第 " + i + "个视频：");
					webName[i] = new Array();
					webNamep[i] = new Array();
					webUrl[i] = new Array();
					for(var key in jsonAnimation[i]){ 	//对该视频的每一对key-value
						if(key != "video_name"){
							//webName[i][j] = changeWebsiteToZh(key) + ": " + jsonAnimation[i][key] + "<br />";
							webNamep[i][j] = key + ": " + jsonAnimation[i][key];
							webName[i][j] = changeWebsiteToZh(key);
							webUrl[i][j] = jsonAnimation[i][key];
							j++;
						}
						else{
							var animationName = jsonAnimation[i].video_name ;
							//animationNameStr += "<input type='radio' id=\"animationname" + i + "\" name='radioVideoName' value=\"" + animationName + "\" />" + animationName + '\r\n';
							trs += "<tr><td><input type='radio' id=\"animationname" + i + "\" name='radioVideoName' value=\"" + animationName + "\" /></td><td>"
							+ animationName
							+ "</td><td>"
							+ j + "个网站"
							+ "</td></tr>";
						}
					}
				}
				//$("#video-name-form").append(animationNameStr);
				$("#piliang-video-list-tbody").append(trs);
				
				//根据视频列表单选框选中值在“包含网站”中显示
				$("input[type='radio'][name='radioVideoName']").mouseover(function(){
				    $("#" + this.id).click(function(){
				    	var sub = this.id.substr(13);	
				    	var subNum = parseInt(sub);	//subNum 对应于 视频的编号
				    	//$("#included-web-form").empty();
				    	$("#piliang-included-web-tbody").empty();
				    	//下面是添加按钮（用于选择视频网站）
				    	for(var i=0; i<webName[subNum].length; i++){	//i 对应于 某一视频的不同网站的编号
				    		/* var webBtn = "";
				    		webBtn += "<input type='checkbox' id=\"animationbtn" + subNum + "-" + i + "\" name='checkboxWebsite' value=\"" + webNamep[subNum][i] + "\" />" + webName[subNum][i] + '\r\n';
				    		$("#included-web-form").append(webBtn); */
				    		var trs = "";
				    		trs += "<tr><td><input type='checkbox' id=\"animationbtn" + subNum + "-" + i + "\" name='checkboxWebsite' checked='checked' value=\"" + webNamep[subNum][i] + "\" /></td><td>"
							+ webName[subNum][i]
							//+ "</td><td>"
							//+ webUrl[subNum][i]
							+ "</td><td class='address'>"
							+ "<a href='" + webUrl[subNum][i] +"' target='_blank' data-url=" + webUrl[subNum][i] + ">" + webUrl[subNum][i] + "</a>" 
							+ "<div>" + webUrl[subNum][i] + "</div></td><td>"
							
							+ "</td></tr>";
				    		$("#piliang-included-web-tbody").append(trs);
				    	} 
				    });	//the end of radio click function
				  });	//the end of $("input[type='radio']").mouseover function
				
			});	// the end of radio_movie click function
			
			/* //get测评节点 for choose-node
			var nodeStr = "";
			var node_name_ip = "";
			var jsonNode = jsonObj.ret_info.node;
			$("#choose-node-form").empty();
			for(var i=0; i<jsonNode.length; i++){
				node_name_ip = jsonNode[i].node_name + " " + jsonNode[i].node_ip + '\r\n'; 
				var nodeID = jsonNode[i].node_id;
				nodeStr += "<input type='radio' id=\"node-choose-" + i + "\" name='radioNodeChoose' value=\"" + nodeID + "\" />" + node_name_ip + '\r\n';
			}
			$("#choose-node-form").append(nodeStr); */
			
		} //the end of  if(jsonObj.ret_code == 0)
	});	//the end of get 回调funciton
	
	//6666----------------------------------日期筛选----------------------------------start
	var now = new Date();
	var year = now.getFullYear(); 
	var month = now.getMonth() + 1;
    var date = now.getDate();
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
	var edFormatDate = "";
	edFormatDate = year + month + date; 
	$("#cycle-end-time").attr('placeholder',edFormatDate);
	//$("#single-cycle-end-time").attr('placeholder',edFormatDate);
	 
	var lastNow = new Date(now);
	lastNow.setDate(lastNow.getDate() - 30); 
	year = lastNow.getFullYear();
	month = lastNow.getMonth()+1;
	date = lastNow.getDate();
	if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
	var stFormatDate = "";
	stFormatDate = year + month + date;
	$("#cycle-start-time").attr('placeholder',stFormatDate);
	//$("#single-cycle-start-time").attr('placeholder',stFormatDate);
	
	//----------------------------------日期筛选----------------------------------------end
	
}	//the end of newJobGetInfo()
</script>

<title>Taveen Console</title>
</head>

<body>
	<div>
		<!-- 用户名隐藏域 -->
		<input id="hidden-username" type="hidden" value="${username}">
		<nav class="navbar navbar-default" style="margin-bottom: 0px;">
			
			<div class="container-fluid">
				<div class="navbar-header">
			      <a class="navbar-brand" style="width: 214px;" href="#">天问QES测量平台</a>
			    </div>
			</div>
		   	<div class="collapse navbar-collapse">
		   		 <ul class="nav navbar-nav">
			   		<li class="active" id="web-video-measure"><a href="#">网络视频测量</a></li>
			   		<li id="video-web-measure"><a href="#">视频网站数据</a></li>
		   		</ul>
			     <ul class="nav navbar-nav navbar-right">
			        <li id="user-help" ><a href="#">FAQ</a></li>
			        <li class="dropdown">
			          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">设置 <span class="caret"></span></a>
			          <ul class="dropdown-menu">
			            <li id="node-management"><a href="#">节点管理</a></li>
			            <li id="user-management"><a href="#">用户管理</a></li>
			            <li id="data-management"><a href="#">数据导出</a></li>
			            <li id="data-delete"><a href="#">数据清理</a></li>
			          </ul>
			        </li>
			        <li><a id="user-name" href="#">用户名</a></li>
			        <li><a id="logout-span" href="#">退出</a></li>
			      </ul>
		    </div>
		</nav>
	</div>

		<table cellpadding="0" cellspacing="0" >
			<tr>
				<td class="common-background-color">
					<div>
						<div class="func-tab-div">
							<a data-toggle="collapse" href="#collapseOne">视频测量任务<span id="collapse-span-1"></span></a>
						</div>
						<div id="collapseOne" class="panel-collapse collapse in">
							<div id="task-latest-list-func" class="func-list">开始测量</div>
							<div id="task-finished-list-func" class="func-list">任务查看</div>
							<div id="task-report-list-func" class="func-list">报告查看</div>
							<!-- <div id="task-multi-list-func" class="func-list">测量计划</div> -->
							<!-- <div id="task-local-list-func" class="func-list">本地任务</div> -->
						</div>
						
						<div class="func-tab-div">
							<a data-toggle="collapse" data-parent="#accordion"  href="#collapseTwo">视频测量计划<span id="collapse-span-2"></span></a>
						</div>
						<div id="collapseTwo" class="panel-collapse collapse">
							<div id="task-multi-list-func" class="func-list">计划管理</div>
							<div id="task-multiReport-list-func" class="func-list">任务查看</div>
							<div id="task-multi-log-list-func" class="func-list">执行日志</div>
						</div>
						
						<div class="func-tab-div" >
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">分类任务浏览<span id="collapse-span-3"></span></a>
						</div>
						<div id="collapseThree" class="panel-collapse collapse">
							<div id="task-youku-list-func" class="func-list">优酷视频</div>
							<div id="task-tudou-list-func" class="func-list">土豆视频</div>
							<div id="task-letv-list-func" class="func-list">乐视视频</div>
							<div id="task-qiyi-list-func" class="func-list">爱 奇 艺</div>
							<div id="task-sohu-list-func" class="func-list">搜狐视频</div>
							<div id="task-qq-list-func" class="func-list">腾讯视频</div>
							<div id="task-cntv-list-func" class="func-list">CNTV视频</div>
							<div id="task-brtn-list-func" class="func-list">BRTN视频</div>
							<!-- <div id="task-other-list-func" class="func-list">其他视频</div> -->
						</div>
						
						<!-- <div class="func-tab-div">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">运行中任务</a>
						</div>
						<div id="collapseThree" class="panel-collapse collapse">
							<div id="task-node1-list-func" class="func-list">节点1</div>
						</div> -->
					</div>
				</td>
				
				<td>
					<!-- 最新的任务列表 -->
					<div id="task-latest-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								开始测量
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-latest" type="hidden" value="0">
								<input id="hidden-st-latest" type="hidden" value="0">
								<input id="hidden-ed-latest" type="hidden" value="0">
								</div>
								
								<div class="btn-group" style="margin-bottom: 10px;">
									<button id="day-1-button"  type="button" class="btn btn-default button-pill button-tiny">1天内</button>
									<span class="margin-right-dist"></span>
									<button id="day-2-button" type="button" class="btn btn-default button-pill button-tiny">2天内</button>
									<span class="margin-right-dist"></span>
									<button id="day-3-button" type="button" class="btn btn-default button-pill button-tiny">3天内</button>
									<span class="margin-right-dist"></span>
									<button id="day-4-button" type="button" class="btn btn-default button-pill button-tiny">4天内</button>
									<span class="margin-right-dist"></span>
									<button id="day-5-button" type="button" class="btn btn-default button-pill button-tiny">5天内</button>
									<span class="margin-right-dist"></span>
									<button id="day-6-button" type="button" class="btn btn-default button-pill button-tiny">6天内</button>
									<span class="margin-right-dist"></span>
									<button id="day-7-button" type="button" class="btn btn-default button-pill button-tiny">1周内</button>
								</div>

								<table class="table table-hover" >
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th>视频网站</th>
											<th width="360px;">视频地址</th>
											<th>测评点</th>
											<!-- <th>计划</th> -->
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-latest-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-latest" class="page-jump-span">上一页</span> <span id="next-page-task-latest" class="page-jump-span">下一页</span>
									<span id="first-page-task-latest" class="page-jump-span">首页</span> <span id="last-page-task-latest" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-latest-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-latest-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
						<div class="under-page-jump-div">
								<div class="input-group-btn">
				                  <button type="button" class="btn btn-default create-task-button" data-toggle="modal" data-target="#createVideoModal" tabindex="-1">
				                  	 创建测量任务
				                  </button>
				                  
				                  <button type="button" style="width:33px;height:33px;" class="btn btn-default dropdown-toggle" data-toggle="dropdown" tabindex="-1">
				                     <span class="caret"></span>
				                  </button>
				                  <ul class="dropdown-menu">
				                     <li><a class="create-task-button" data-toggle="modal" data-target="#createVideoModal" >创建测量任务</a></li>
				                     <li><a class="create-local-task-button" data-toggle="modal" data-target="#createlocalVideoModal" >本地样例视频</a></li>
				                  </ul> 
								  
								  <!-- <span class="margin-right-dist"></span>
								  <input id="delete-task-button-latest" class="btn btn-default button-rounded" type="button" value="删除测量任务" /> -->									
				               </div><!-- /btn-group -->
						</div>
					</div>
					
					<!-- 结束运行的任务列表 -->
					<div id="task-finished-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								所有任务
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-finished" type="hidden" value="0">
								<input id="hidden-st-finished" type="hidden" value="0">
								<input id="hidden-ed-finished" type="hidden" value="0">
								</div>
							
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-finished" class="margin-right-dist date-width" type="text" >
							    <!-- <input id="st-date-finished" class="inputDate" value="04/22/2016"> -->
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-finished" class="margin-right-dist date-width" type="text" >
							    <button data-type="finished" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
								    
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th>视频网站</th>
											<th width="360px;">视频地址</th>
											<th>测评点</th>
											<!-- <th>计划</th> -->
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
											<th>删除</th>
										</tr>
									</thead>
									<tbody id="task-finished-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-finished" class="page-jump-span">上一页</span> <span id="next-page-task-finished" class="page-jump-span">下一页</span>
									<span id="first-page-task-finished" class="page-jump-span">首页</span> <span id="last-page-task-finished" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-finished-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-finished-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
								<div class="under-page-jump-div">
									<input id="delete-task-button-finished" class="btn btn-default button-rounded" type="button" value="删除测量任务" />									
								</div>
					</div>
					
					
					<!-- 视频测量任务-测量结果的任务列表 -->
					<div id="task-report-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								测量结果
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-report" type="hidden" value="0">
								<input id="hidden-st-report" type="hidden" value="0">
								<input id="hidden-ed-report" type="hidden" value="0">
								</div>
							
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-report" class="margin-right-dist date-width" type="text" >
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-report" class="margin-right-dist date-width" type="text" >
							    <button data-type="report" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th>视频网站</th>
											<th width="360px;">视频地址</th>
											<th>测评点</th>
											<!-- <th>计划</th> -->
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-report-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-report" class="page-jump-span">上一页</span> <span id="next-page-task-report" class="page-jump-span">下一页</span>
									<span id="first-page-task-report" class="page-jump-span">首页</span> <span id="last-page-task-report" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-report-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-report-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
					
					<!-- 视频测量计划-测量结果的任务列表 -->
					<div id="task-multiReport-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								测量结果
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-multiReport" type="hidden" value="0">
								<input id="hidden-st-multiReport" type="hidden" value="0">
								<input id="hidden-ed-multiReport" type="hidden" value="0">
								</div>
							
								<div style="margin-bottom: 15px;">
									<span style="width:75px;">开始日期：</span>
								    <input id="st-date-multiReport" class="margin-right-dist date-width" type="text" >
								    <span class="margin-right-dist"></span>
								    <span style="width:75px;">结束日期：</span>
								    <input id="ed-date-multiReport" class="margin-right-dist date-width" type="text" >
									
									<span class="margin-right-dist"></span>
									<span style="width:75px;">计划名称：</span>
									    <div class="btn-group">
										   <button id = "selected-task-button" type="button" class="btn btn-default">全部</button>
										   <button type="button" class="btn btn-default dropdown-toggle" 
										      data-toggle="dropdown">
										      <span class="caret"></span>
										      <span class="sr-only">切换下拉菜单</span>
										   </button>
										   <ul id="nameFilter-multiReport-ul" class="dropdown-menu" role="menu">
										   
										   </ul>
										</div>
									
									<span class="margin-right-dist"></span>
								    <button data-type="multiReport" class="select-task-by-date-name btn btn-default button-rounded button-tiny">筛选任务</button>
								
								</div>
								
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th>视频网站</th>
											<th width="360px;">视频地址</th>
											<th>测评点</th>
											<th>计划</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
											<th>删除</th>
										</tr>
									</thead>
									<tbody id="task-multiReport-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-multiReport" class="page-jump-span">上一页</span> <span id="next-page-task-multiReport" class="page-jump-span">下一页</span>
									<span id="first-page-task-multiReport" class="page-jump-span">首页</span> <span id="last-page-task-multiReport" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-multiReport-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-multiReport-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
						
						<div class="under-page-jump-div">
								<input id="delete-task-button-multi2" class="btn btn-default button-rounded" type="button" value="删除测量任务" />									
						</div>
					</div>
					
					<!-- 视频测量计划-执行日志 -->
					<div id="task-multi-log-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								执行日志
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-multi-log" type="hidden" value="0">
								<input id="hidden-st-multi-log" type="hidden" value="0">
								<input id="hidden-ed-multi-log" type="hidden" value="0">
								</div>
							
								<!-- <div style="margin-bottom: 15px;">
									<span style="width:75px;">开始日期：</span>
								    <input id="st-date-multi-log" class="margin-right-dist date-width" type="text" >
								    <span class="margin-right--log"></span>
								    <span style="width:75px;">结束日期：</span>
								    <input id="ed-date-multiReport" class="margin-right-dist date-width" type="text" >
									
									<span class="margin-right-dist"></span>
									<span style="width:75px;">计划名称：</span>
									    <div class="btn-group">
										   <button id = "selected-task-button" type="button" class="btn btn-default">全部</button>
										   <button type="button" class="btn btn-default dropdown-toggle" 
										      data-toggle="dropdown">
										      <span class="caret"></span>
										      <span class="sr-only">切换下拉菜单</span>
										   </button>
										   <ul id="nameFilter-multi-log-ul" class="dropdown-menu" role="menu">
										   
										   </ul>
										</div>
									
									<span class="margin-right-dist"></span>
								    <button data-type="multiReport" class="select-task-by-date-name btn btn-default button-rounded button-tiny">筛选任务</button>
								
								</div> -->
								
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>视频名称</th>
											<th>计划起止日期</th>
											<th>详情</th>
											<th>执行日期</th>
											<th>状态
												（<span style="color:red;"> 错误 </span> 或  完成  ）
											</th>
										</tr>
									</thead>
									<tbody id="task-multi-log-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-multi-log" class="page-jump-span">上一页</span> <span id="next-page-task-multi-log" class="page-jump-span">下一页</span>
									<span id="first-page-task-multi-log" class="page-jump-span">首页</span> <span id="last-page-task-multi-log" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-multi-log-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-multi-log-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
						
						<!-- <div class="under-page-jump-div">
								<input id="delete-task-button-multi-log" class="btn btn-default button-rounded" type="button" value="删除测量任务" />									
						</div> -->
					</div>
					
					
					<!-- 本地任务列表 -->
					<div id="task-local-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								本地任务
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-local" type="hidden" value="0">
								<input id="hidden-st-local" type="hidden" value="0">
								<input id="hidden-ed-local" type="hidden" value="0">
								</div>
							
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-local" class="margin-right-dist date-width"  type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-local" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="local" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover" width="100%">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-local-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-local" class="page-jump-span">上一页</span> <span id="next-page-task-local" class="page-jump-span">下一页</span>
									<span id="first-page-task-local" class="page-jump-span">首页</span> <span id="last-page-task-local" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-local-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-local-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
						
						<!-- <div class="under-page-jump-div">
								<div class="input-group-btn">
				                  <button type="button" class="btn btn-default create-local-task-button" data-toggle="modal" data-target="#createlocalVideoModal" tabindex="-1">
				                  	 本地样例视频
				                  </button>
								  <span class="margin-right-dist"></span>
								  <input id="delete-task-button-latest" class="btn btn-default button-rounded" type="button" value="删除测量任务" />									
				               </div>/btn-group
						</div> -->
						
						
						<!-- <div class="under-page-jump-div">
							<input class="create-local-task-button button button-primary button-rounded" data-toggle="modal" data-target="#createlocalVideoModal" type="button" value="创建本地任务" />
						</div> -->
					</div>
					
					
					<!-- 批量视频任务列表 -->
					<div id="task-multi-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								测量计划
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-multi" type="hidden" value="0">
								<input id="hidden-st-multi" type="hidden" value="0">
								<input id="hidden-ed-multi" type="hidden" value="0">
								</div>
							
							
								<table class="table table-hover" width="100%">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th>测评网站</th>
											<th>测评点</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>运行状态</th>
											<!-- <th>任务查看</th> -->
											<th>详情</th>
											<th>计划操作</th>
											<th>删除</th>
										</tr>
									</thead>
									<tbody id="task-multi-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-multi" class="page-jump-span">上一页</span> <span id="next-page-task-multi" class="page-jump-span">下一页</span>
									<span id="first-page-task-multi" class="page-jump-span">首页</span> <span id="last-page-task-multi" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-multi-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-multi-current-page-span">1</span>页</span>
								</div>
								
							</div>	<!-- the end of panel-body -->
						</div>
						<div class="under-page-jump-div">
							<div class="input-group-btn">
								<!-- <button type="button" class="btn btn-default create-task-button" data-toggle="modal" data-target="#createVideoModal" tabindex="-1">
				                 	创建测量任务
				                </button> -->
								<input id="create-task-button-latest" class="btn btn-default button-rounded" type="button" onclick= "newJobGetInfo()" data-toggle="modal" data-target="#createMultiVideoModal" value="新建测量计划" />
								<button type="button" style="width:33px;height:33px;" class="btn btn-default dropdown-toggle" data-toggle="dropdown" tabindex="-1">
			                    	<span class="caret"></span>
			                  	</button>
			                  	<ul class="dropdown-menu">
			                     	<li><a class="create-task-button" onclick= "newJobGetInfo()" data-toggle="modal" data-target="#createMultiVideoModal" >多网站测量计划</a></li>
			                     	<li><a id="create-single-task-button" data-toggle="modal" data-target="#createSingleVideoModal" >单网站测量计划</a></li>
			                    </ul>
								
								<span class="margin-right-dist"></span>
								<input id="delete-task-button-piliang" class="btn btn-default button-rounded" type="button" value="删除测量计划" />
							</div>
						</div>
						
					</div>
					
					
					
					<!-- youku的任务列表 -->
					<div id="task-youku-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								优酷视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-youku" type="hidden" value="0">
								<input id="hidden-st-youku" type="hidden" value="0">
								<input id="hidden-ed-youku" type="hidden" value="0">
								</div>
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-youku" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-youku" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="youku" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-youku-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-youku" class="page-jump-span">上一页</span> <span id="next-page-task-youku" class="page-jump-span">下一页</span>
									<span id="first-page-task-youku" class="page-jump-span">首页</span> <span id="last-page-task-youku" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-youku-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-youku-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
								<!-- <div class="under-page-jump-div">
									<input class="create-task-button button button-primary button-rounded" data-toggle="modal" data-target="#createVideoModal" type="button" value="创建测量任务" />
								</div> -->
					</div>
					<!-- tudou的任务列表 -->
					<div id="task-tudou-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								土豆视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-tudou" type="hidden" value="0">
								<input id="hidden-st-tudou" type="hidden" value="0">
								<input id="hidden-ed-tudou" type="hidden" value="0">
								</div>
							
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-tudou" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-tudou" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="tudou" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-tudou-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-tudou" class="page-jump-span">上一页</span> <span id="next-page-task-tudou" class="page-jump-span">下一页</span>
									<span id="first-page-task-tudou" class="page-jump-span">首页</span> <span id="last-page-task-tudou" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-tudou-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-tudou-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
								<!-- <div class="under-page-jump-div">
									<input class="create-task-button button button-primary button-rounded" data-toggle="modal" data-target="#createVideoModal" type="button" value="创建测量任务" />
								</div> -->
					</div>
					<!-- letv的任务列表 -->
					<div id="task-letv-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								乐视视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-letv" type="hidden" value="0">
								<input id="hidden-st-letv" type="hidden" value="0">
								<input id="hidden-ed-letv" type="hidden" value="0">
								</div>
								
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-letv" class="margin-right-dist date-width" type="text">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-letv" class="margin-right-dist date-width" type="text">
							    <button data-type="letv" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-letv-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-letv" class="page-jump-span">上一页</span> <span id="next-page-task-letv" class="page-jump-span">下一页</span>
									<span id="first-page-task-letv" class="page-jump-span">首页</span> <span id="last-page-task-letv" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-letv-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-letv-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
								<!-- <div class="under-page-jump-div">
									<input class="create-task-button button button-primary button-rounded" data-toggle="modal" data-target="#createVideoModal" type="button" value="创建测量任务" />
								</div> -->
					</div>
					<!-- qiyi的任务列表 -->
					<div id="task-qiyi-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								爱奇艺视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-qiyi" type="hidden" value="0">
								<input id="hidden-st-qiyi" type="hidden" value="0">
								<input id="hidden-ed-qiyi" type="hidden" value="0">
								</div>
							
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-qiyi" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-qiyi" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="qiyi" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-qiyi-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-qiyi" class="page-jump-span">上一页</span> <span id="next-page-task-qiyi" class="page-jump-span">下一页</span>
									<span id="first-page-task-qiyi" class="page-jump-span">首页</span> <span id="last-page-task-qiyi" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-qiyi-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-qiyi-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
								<!-- <div class="under-page-jump-div">
									<input class="create-task-button button button-primary button-rounded" data-toggle="modal" data-target="#createVideoModal" type="button" value="创建测量任务" />
								</div> -->
					</div>
					<!-- sohu的任务列表 -->
					<div id="task-sohu-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								搜狐视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-sohu" type="hidden" value="0">
								<input id="hidden-st-sohu" type="hidden" value="0">
								<input id="hidden-ed-sohu" type="hidden" value="0">
								</div>
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-sohu" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-sohu" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="sohu" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-sohu-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-sohu" class="page-jump-span">上一页</span> <span id="next-page-task-sohu" class="page-jump-span">下一页</span>
									<span id="first-page-task-sohu" class="page-jump-span">首页</span> <span id="last-page-task-sohu" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-sohu-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-sohu-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
								<!-- <div class="under-page-jump-div">
									<input class="create-task-button button button-primary button-rounded" data-toggle="modal" data-target="#createVideoModal" type="button" value="创建测量任务" />
								</div> -->
					</div>
					
					<!-- qq的任务列表 -->
					<div id="task-qq-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								腾讯视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-qq" type="hidden" value="0">
								<input id="hidden-st-qq" type="hidden" value="0">
								<input id="hidden-ed-qq" type="hidden" value="0">
								</div>
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-qq" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-qq" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="qq" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-qq-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-qq" class="page-jump-span">上一页</span> <span id="next-page-task-qq" class="page-jump-span">下一页</span>
									<span id="first-page-task-qq" class="page-jump-span">首页</span> <span id="last-page-task-qq" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-qq-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-qq-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
					
					<!-- cntv的任务列表 -->
					<div id="task-cntv-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								CNTV 视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-cntv" type="hidden" value="0">
								<input id="hidden-st-cntv" type="hidden" value="0">
								<input id="hidden-ed-cntv" type="hidden" value="0">
								</div>
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-cntv" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-cntv" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="cntv" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-cntv-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-cntv" class="page-jump-span">上一页</span> <span id="next-page-task-cntv" class="page-jump-span">下一页</span>
									<span id="first-page-task-cntv" class="page-jump-span">首页</span> <span id="last-page-task-cntv" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-cntv-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-cntv-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
					
					<!-- brtn的任务列表 -->
					<div id="task-brtn-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								BRTN 视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-brtn" type="hidden" value="0">
								<input id="hidden-st-brtn" type="hidden" value="0">
								<input id="hidden-ed-brtn" type="hidden" value="0">
								</div>
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-brtn" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-brtn" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="brtn" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-brtn-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-brtn" class="page-jump-span">上一页</span> <span id="next-page-task-brtn" class="page-jump-span">下一页</span>
									<span id="first-page-task-brtn" class="page-jump-span">首页</span> <span id="last-page-task-brtn" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-brtn-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-brtn-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
					
					
					<!-- other的任务列表 -->
					<div id="task-other-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								其他视频
							</div>
							<div class="panel-body">
								<div>
								<input id="hidden-num-other" type="hidden" value="0">
								<input id="hidden-st-other" type="hidden" value="0">
								<input id="hidden-ed-other" type="hidden" value="0">
								</div>
								
								<div style="margin-bottom: 15px;">
								<span style="width:75px;">开始日期：</span>
							    <input id="st-date-other" class="margin-right-dist date-width" type="text"  placeholder="20150101">
							    <span class="margin-right-dist"></span>
							    <span style="width:75px;">结束日期：</span>
							    <input id="ed-date-other" class="margin-right-dist date-width" type="text"  placeholder="20151231">
							    <button data-type="other" class="select-task-by-date btn btn-default button-rounded button-tiny">筛选任务</button>
								</div>
							
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务查看</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-other-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-other" class="page-jump-span">上一页</span> <span id="next-page-task-other" class="page-jump-span">下一页</span>
									<span id="first-page-task-other" class="page-jump-span">首页</span> <span id="last-page-task-other" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-other-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-other-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
					
					
					<!-- 节点一的任务列表 -->
					<div id="task-node1-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								节点1
							</div>
							<div class="panel-body">
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-node1-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-node1" class="page-jump-span">上一页</span> <span id="next-page-task-node1" class="page-jump-span">下一页</span>
									<span id="first-page-task-node1" class="page-jump-span">首页</span> <span id="last-page-task-node1" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-node1-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-node1-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
					
					<!-- 节点二的任务列表 -->
					<div id="task-node2-list-form" class="taveen-func-form">
						<div class="panel panel-default">
							<div class="panel-heading">
								节点DEF
							</div>
							<div class="panel-body">
								<table class="table table-hover">
									<thead>
										<tr>
											<th>#</th>
											<th width="160px;">视频名称</th>
											<th width="360px;">视频地址</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>状态</th>
											<th>任务操作</th>
										</tr>
									</thead>
									<tbody id="task-node2-list-tbody">
					
									</tbody>
								</table>
								<div class="page-jump-div">
									<span id="previous-page-task-node2" class="page-jump-span">上一页</span> <span id="next-page-task-node2" class="page-jump-span">下一页</span>
									<span id="first-page-task-node2" class="page-jump-span">首页</span> <span id="last-page-task-node2" class="page-jump-span">尾页</span>
									<span class="total-current-style-class">总共<span id="task-node2-total-count-span"></span>页</span>
									<span class="total-current-style-class">当前第<span id="task-node2-current-page-span">1</span>页</span>
								</div>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</table>
	
		
		<!-- 创建测量任务模态框（Modal） -->
		<div class="modal fade" id="createVideoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="myModalLabel">创建测量任务</h4>
		         </div>
		         <div class="modal-body">
		         	<div id="step-1-body-div">
			         	<div class="input-group">
						   <span class="input-group-addon" style="font-weight:bold">视频名称</span>
						   <input id="video-name-text" type="text" class="form-control" placeholder="视频名称">
						</div>
			
						<div class="input-group margin-top-dist">
						   <span class="input-group-addon" style="font-weight:bold">视频网址</span>
						   <input id="video-url-text" type="text" class="form-control" placeholder="视频地址">
						</div>
				   		
				   		<br />
			         	<div class="panel panel-info">
						   <div class="panel-heading">
								<h3 class="panel-title">网络视频</h3>
						   </div>
						   <div class="panel-body">
						   		<div id="video-site-div" class="margin-top-dist">
									<label  style="width:65px;">网站：</label>
									<input type="checkbox" name="websiteCheckbox" value="youku" checked='checked'><span class="margin-right-dist">优酷</span>
									<input type="checkbox" name="websiteCheckbox" value="tudou"><span class="margin-right-dist">土豆</span>
									<input type="checkbox" name="websiteCheckbox" value="letv"><span class="margin-right-dist">乐视</span>
									<input type="checkbox" name="websiteCheckbox" value="qq"><span class="margin-right-dist">腾讯</span>
									<input type="checkbox" name="websiteCheckbox" value="qiyi"><span class="margin-right-dist">爱奇艺</span>
									<input type="checkbox" name="websiteCheckbox" value="sohu"><span class="margin-right-dist">搜狐</span>
									<input type="checkbox" name="websiteCheckbox" value="cntv"><span class="margin-right-dist">CNTV</span>
									<input type="checkbox" name="websiteCheckbox" value="brtn"><span class="margin-right-dist">BRTN</span>
								</div>	
						   		
						   		<div id="video-type-div" class="margin-top-dist">
									<label style="width:65px;">类型：</label>
									<input type="checkbox" name="videoTypeCheckbox" value="movie" checked='checked'><span class="margin-right-dist">电影</span>
									<input type="checkbox" name="videoTypeCheckbox" value="tv"><span class="margin-right-dist">电视剧</span>
									<input type="checkbox" name="videoTypeCheckbox" value="show"><span class="margin-right-dist">综艺</span>
									<input type="checkbox" name="videoTypeCheckbox" value="comic"><span class="margin-right-dist">动漫</span>
								</div>
						   		
						   		<div class="margin-top-dist">
								    <label style="width:65px;">关键字：</label>
								    <input id="video-keyword-text" class="margin-right-dist" type="text"  placeholder="关键字">
								</div>
						   
								<div class="margin-top-dist">
								    <label style="width:65px;">数量：</label>
								    <input id="video-count-text" class="margin-right-dist" type="text"  value="10" >
								    <button class="btn btn-default button-rounded button-tiny create-task-button">筛选视频</button>
								    <span class="margin-right-dist"></span>
								    <button class="btn btn-default button-rounded button-tiny reset-button">重置</button>
								</div>
								<br/>
						   		
								<input id="hidden-page-value-videolist" type="hidden" value="0">
								<div class="table-scroll">
									<table class="table table-hover">
										<thead>
											<tr>
												<th>选择</th>
												<th>视频名称</th>
												<th>视频地址</th>
											</tr>
										</thead>
										<tbody id="video-list-tbody">
									
										</tbody>
									</table>
								</div>
						   </div>
						</div>
		         	</div><!-- step-1-body-div -->

					<div id="step-2-body-div" style="display:none">
						<div class="panel panel-info">
						   <div class="panel-heading">
						      <h3 class="panel-title">测量参数</h3>
						   </div>
						   <div class="panel-body">
						   	  <div id="loading-div"><img id="loading-img" alt="loading" src="../images/loading.gif"></div>
						      <div id="resolution-div" class="margin-top-dist">
							  </div>	
							  <div class="margin-top-dist">
									<div id="choose-node-div" class="margin-top-dist">
										<table>
											<tr>
												<td>
													<label class="margin-right-dist">测评点：</label>
												</td>
												<td>
													<form id="latest-choose-node-form">
											
													</form>
												</td>
											</tr>
										</table>
									</div>
							  </div>
						   </div>
						   
						</div>
					</div><!-- step-2-body-div -->
		         </div>
		         <div class="modal-footer">
		         	<div id="step-1-div">
			            <button class="button button-rounded" data-dismiss="modal">取消创建</button>
			            <button class="button button-primary button-rounded" id="step-next-button">下一步</button>
		         	</div>
		         	<div id="step-2-div" style="display:none">
			            <button class="button button-rounded" data-dismiss="modal">取消创建</button>
			            <button class="button button-primary button-rounded" id="task-create-button">确认创建</button>
		         	</div>
		         </div>
		      </div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
		
		
		<!-- 本地任务 模态框（Modal） -->
		<div class="modal fade" id="createlocalVideoModal" tabindex="-1" role="dialog" aria-labelledby="localVideoModalLabel" aria-hidden="true">
		   	<div class="modal-dialog">
		      	<div class="modal-content">
			         <div class="modal-header">
			            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
			            <h4 class="modal-title" id="localVideoModalLabel">创建测量任务</h4>
			         </div>
			         <div class="modal-body">
						<div class="input-group">
						   <span class="input-group-addon" style="font-weight:bold">视频名称</span>
						   <input id="localvideo-name-text" type="text" class="form-control" placeholder="视频名称">
						</div>
			
						<div class="input-group margin-top-dist">
						   <span class="input-group-addon" style="font-weight:bold">视频网址</span>
						   <input id="localvideo-url-text" type="text" class="form-control" placeholder="视频地址">
						</div>
				   		
				   			<br/>
				         	<div class="panel panel-info">
							   <div class="panel-heading">
									<h3 class="panel-title">网络视频</h3>
							   </div>
							   <div class="panel-body">
										<input id="hidden-page-value-videolist" type="hidden" value="0">
										<div class="table-scroll">
											<table class="table table-hover">
												<thead>
													<tr>
														<th>选择</th>
														<th>视频名称</th>
														<th>视频地址</th>
													</tr>
												</thead>
												<tbody id="local-video-list-tbody">
											
												</tbody>
											</table>
										</div>
							   </div>
							</div>
					 </div>
		      	
			         <div class="modal-footer">
			            <button class="button button-rounded" data-dismiss="modal">取消创建</button>
			            <button class="button button-primary button-rounded" id="local-task-create-button">确认创建</button>
			         </div>
		      	</div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
			<!-- 模态框（Modal） -->  <!-- 创建单个任务模态框 -->
		<div class="modal fade" id="createSingleVideoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
		        	<div class="modal-header">
		        		<button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            	<h4 class="modal-title" id="singleVideoModalLabel">单网站测量计划</h4>
		        	</div>
		        	
		        	<div class="modal-body">
		        		<div id="single-step-1-body-div">
				        	<div class="input-group">
							   <span class="input-group-addon" style="font-weight:bold">视频名称</span>
							   <input id="single-video-name-text" type="text" class="form-control" placeholder="视频名称">
							</div>
				
							<div class="input-group margin-top-dist">
							   <span class="input-group-addon" style="font-weight:bold">视频网址</span>
							   <input id="single-video-url-text" type="text" class="form-control" placeholder="视频地址">
							</div>
					   		<br />	
		        		
		        			<div class="panel panel-info">
		        				<div class="panel-heading">
		         					<h3 class="panel-title">网络视频</h3>
		         				</div>
		        				<div class="panel-body">
			        					<div id="video-site-div" class="margin-top-dist">
											<label  style="width:65px;">网站：</label>
											<input type="checkbox" name="websiteCheckbox" value="youku" ><span class="margin-right-dist">优酷</span>
											<input type="checkbox" name="websiteCheckbox" value="tudou"><span class="margin-right-dist">土豆</span>
											<input type="checkbox" name="websiteCheckbox" value="letv"><span class="margin-right-dist">乐视</span>
											<input type="checkbox" name="websiteCheckbox" value="qq"><span class="margin-right-dist">腾讯</span>
											<input type="checkbox" name="websiteCheckbox" value="qiyi"><span class="margin-right-dist">爱奇艺</span>
											<input type="checkbox" name="websiteCheckbox" value="sohu"><span class="margin-right-dist">搜狐</span>
											<input type="checkbox" name="websiteCheckbox" value="cntv"><span class="margin-right-dist">CNTV</span>
											<input type="checkbox" name="websiteCheckbox" value="brtn"><span class="margin-right-dist">BRTN</span>
										</div>	
							   		
								   		<div id="video-type-div" class="margin-top-dist">
											<label style="width:65px;">类型：</label>
											<input type="checkbox" name="videoTypeCheckbox" value="movie"><span class="margin-right-dist">电影</span>
											<input type="checkbox" name="videoTypeCheckbox" value="tv"><span class="margin-right-dist">电视剧</span>
											<input type="checkbox" name="videoTypeCheckbox" value="show"><span class="margin-right-dist">综艺</span>
											<input type="checkbox" name="videoTypeCheckbox" value="comic"><span class="margin-right-dist">动漫</span>
										</div>
							   		
								   		<div class="margin-top-dist">
										    <label style="width:65px;">关键字：</label>
										    <input id="video-keyword-text" class="margin-right-dist" type="text"  placeholder="关键字">
										</div>
							   
										<div class="margin-top-dist">
										    <label style="width:65px;">数量：</label>
										    <input id="video-count-text" class="margin-right-dist" type="text"  value="10" >
										    <button class="btn btn-default button-rounded button-tiny create-single-task-button">筛选视频</button>
										    <span class="margin-right-dist"></span>
										    <button class="btn btn-default button-rounded button-tiny reset-button">重置</button>
										</div>
										<br/>
							   		
										<input id="hidden-page-value-videolist" type="hidden" value="0">
										<div class="table-scroll">
											<table class="table table-hover">
												<thead>
													<tr>
														<th>选择</th>
														<th>视频名称</th>
														<th>视频类型</th>
														<th>视频网站</th>
														<th>视频地址</th>
													</tr>
												</thead>
												<tbody id="single-video-list-tbody">
													
												</tbody>
											</table>
										</div>
		        					
		        				</div>	<!-- the end of  panel-body -->
		        			</div>	<!-- the end of the 1st panel-info -->
		        			
		        			<div class="panel panel-info">	
								<div class="panel-heading">	
									<h3 class="panel-title">测量时间</h3>
								</div>
								<div class="panel-body">
									<div id="test-week-div" class="margin-top-dist">
										<label  style="width:160px;">每周测量时间：</label>
										<input type="checkbox" name="weekCheckboxMulti"  value="mon" ><span class="margin-right-dist">周一</span>
										<input type="checkbox" name="weekCheckboxMulti" value="tue"><span class="margin-right-dist">周二</span>
										<input type="checkbox" name="weekCheckboxMulti" value="wed"><span class="margin-right-dist">周三</span>
										<input type="checkbox" name="weekCheckboxMulti" value="thu"><span class="margin-right-dist">周四</span>
										<input type="checkbox" name="weekCheckboxMulti" value="fri"><span class="margin-right-dist">周五</span>
										<input type="checkbox" name="weekCheckboxMulti" value="sat"><span class="margin-right-dist">周六</span>
										<input type="checkbox" name="weekCheckboxMulti" value="sun"><span class="margin-right-dist">周日</span>
									</div>	
									
									<script type="text/javascript">
										 $(function() {
						                    $('#single-start-time-multi').timepicker({
						                    	disableTextInput: true,
						                    	step: 30,
						                    });
							             });
									</script>
												
									<div id="test-day-div" class="margin-top-dist">
										<table>
											<tr>
												<td>
													<label  style="width:160px;">每天开始测量时间：</label>
												</td>
												<td>
													<input id="single-start-time-multi" type="text" data-time-format="H:i" class="ui-timepicker-input" autocomplete="off">
												</td>
											</tr>
										</table>
									</div>	
										
				        			
						
									<div id="test-cycle-div">
										<label  style="width:160px;">测试周期：</label>
										<input id="single-cycle-start-time" type="text" />--
										<input id="single-cycle-end-time" type="text" "/>
									</div>
										
									<div class="margin-top-dist">
										<table>
											<tr>
												<td>
													 <label style="width:160px;">每个视频测量长度：</label>
												</td>
												<td>
													<form >
													    <input type="radio" name="timeRadioMulti" checked="checked" value="5"><span class="margin-right-dist">5分钟</span>
														<input type="radio" name="timeRadioMulti" value="10"><span class="margin-right-dist">10分钟</span>
														<input type="radio" name="timeRadioMulti" value="15"><span class="margin-right-dist">15分钟</span>
														<input type="radio" name="timeRadioMulti" value="-1"><span class="margin-right-dist">全部</span>
													</form>
												</td>
											</tr>
										</table>
									</div>
								</div>	
							</div>	<!-- the end of the 2nd panel-info -->
							
							<div class="panel panel-info">
			         			<div class="panel-heading">
			         				<h3 class="panel-title">其他</h3>
			         			</div>
			         			<div class="panel-body">
									<div id="video-type-div" class="margin-top-dist">
										<table>
											<tr>
												<td>
													<span>  <span><label style="width:160px;">每个视频优先匹配：</label>
												</td>
												<td>
													<form>
														<input type="radio" name="definitionCheckboxMulti" checked="checked" value="hd"><span class="margin-right-dist">高清</span>
														<input type="radio" name="definitionCheckboxMulti" value="uhd"><span class="margin-right-dist">超高清</span>
														<input type="radio" name="definitionCheckboxMulti" value="sd"><span class="margin-right-dist">标清</span>
													</form>
												</td>
											</tr>
										</table>
									</div>	
									
									<div class="margin-top-dist">
										<div id="choose-node-div" class="margin-top-dist">
											<table>
												<tr>
													<td>
														<label style="width:160px;">测评点：</label>
													</td>
													<td>
														<form id="single-choose-node-form">
												
														</form>
													</td>
												</tr>
											</table>
										</div>
									</div>
			         			
			         			</div>	<!-- the end of the 3rd panel-body -->
		         			</div>	<!-- the end of the 3rd panel-info -->
		        			
		        		</div>	<!-- the end of step-1-body-div -->
		        		
		        	</div>	<!-- /.modal-body -->
		        	
		        	
				    <div class="modal-footer">
			         	<!-- <div id="single-step-1-div">
				            <button class="button button-rounded" data-dismiss="modal">取消创建</button>
				            <button class="button button-primary button-rounded" id="single-step-next-button">下一步</button>
			         	</div> -->
			         	<div id="single-step-1-div" style="display:none">
				            <button class="button button-rounded" data-dismiss="modal">取消创建</button>
				            <button class="button button-primary button-rounded" id="single-video-button">确认创建</button>
			         	</div>
		         	</div>
		        	
		        </div>	<!-- /.modal-content -->
			</div>
		</div>
		
			<!-- 模态框（Modal） -->  <!-- 创建批量任务模态框 -->
		<div class="modal fade" id="createMultiVideoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="multiVideoModalLabel">多网站测量计划</h4>
		         </div>
		         <div class="modal-body">
		         	<div id="step-1-body-div">
		         		<div class="panel panel-info">
		         			<div class="panel-heading">
		         				<h3 class="panel-title">网络视频</h3>
		         			</div>
		         			<div class="panel-body">
		         			
								<div id="video-type-div" class="margin-top-dist">
									<label style="width:160px;">视频类别：</label>
									<input type="radio" id="radio_movie" name="videoTypeRadioMulti" value="movie" checked="checked"><span class="margin-right-dist">电影</span>
									<input type="radio" id="radio_tv" name="videoTypeRadioMulti" value="tv"><span class="margin-right-dist">电视剧</span>
									<input type="radio" id="radio_tv_show" name="videoTypeRadioMulti" value="show"><span class="margin-right-dist">综艺</span>
									<input type="radio" id="radio_animation" name="videoTypeRadioMulti" value="comic"><span class="margin-right-dist">动漫</span>
								</div>
								
								<div id="video-name-list">
									<label style="width:160px;">视频列表：</label>
									<div class="table-scroll">
											<table class="table table-hover">
												<thead>
													<tr>
														<th>选择</th>
														<th>视频名称</th>
														<th>视频网站个数</th>
													</tr>
												</thead>
												<tbody id="piliang-video-list-tbody">
													
												</tbody>
											</table>
									</div>
									<form id="video-name-form">
										
									</form>
								</div>
								
								<div id="included-web-div">
									<label style="width:160px;">包含网站：</label>
									<div class="table-scroll">
											<table class="table table-hover">
												<thead>
													<tr>
														<th>选择</th>
														<th>视频网站</th>
														<th>视频地址</th>
													</tr>
												</thead>
												<tbody id="piliang-included-web-tbody">
													
												</tbody>
											</table>
									</div>
									<form id="included-web-form">
									
									</form>
								</div>
								
		         			</div>    		
							<!-- <div id="video-site-div" class="margin-top-bottom-dist">
								<label  style="width:160px;">评测视频网站范围：</label>
								<input type="checkbox" name="websiteCheckboxMulti" checked="checked" value="youku" ><span class="margin-right-dist">优酷</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="tudou"><span class="margin-right-dist">土豆</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="letv"><span class="margin-right-dist">乐视</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="qq"><span class="margin-right-dist">腾讯</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="qiyi"><span class="margin-right-dist">爱奇艺</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="sohu"><span class="margin-right-dist">搜狐</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="cntv"><span class="margin-right-dist">CNTV</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="brtn"><span class="margin-right-dist">BRTN</span>
								<input type="checkbox" name="websiteCheckboxMulti" value="local"><span class="margin-right-dist">本地</span>
							</div> -->	
						</div>
						
						
						
						<div class="panel panel-info">	
							<div class="panel-heading">	
								<h3 class="panel-title">测量时间</h3>
							</div>
							<div class="panel-body">
							
								<div id="test-week-div" class="margin-top-dist">
									<label  style="width:160px;">每周测量时间：</label>
									<input type="checkbox" name="weekCheckboxMulti"  value="mon" ><span class="margin-right-dist">周一</span>
									<input type="checkbox" name="weekCheckboxMulti" value="tue"><span class="margin-right-dist">周二</span>
									<input type="checkbox" name="weekCheckboxMulti" value="wed"><span class="margin-right-dist">周三</span>
									<input type="checkbox" name="weekCheckboxMulti" value="thu"><span class="margin-right-dist">周四</span>
									<input type="checkbox" name="weekCheckboxMulti" value="fri"><span class="margin-right-dist">周五</span>
									<input type="checkbox" name="weekCheckboxMulti" value="sat"><span class="margin-right-dist">周六</span>
									<input type="checkbox" name="weekCheckboxMulti" value="sun"><span class="margin-right-dist">周日</span>
								</div>	
								
								<script type="text/javascript">
							 		$(function() {
					                    $('#start-time-multi').timepicker({
					                    	disableTextInput: true,
					                    	step: 30,
				                    });
				                });
								</script>	
										
								<div id="test-day-div" class="margin-top-dist">
									<table>
										<tr>
											<td>
												<label  style="width:160px;">每天开始测量时间：</label>
											</td>
											<td>
												<input id="start-time-multi" type="text" data-time-format="H:i" class="ui-timepicker-input" autocomplete="off">
											</td>
										</tr>
									</table>
								</div>	
								
								<div id="test-cycle-div">
									<label  style="width:160px;">测试周期：</label>
									<input id="cycle-start-time" type="text"/>--
									<input id="cycle-end-time" type="text" />
								</div>
								
								<div class="margin-top-dist">
									<table>
										<tr>
											<td>
												 <label style="width:160px;">每个视频测量长度：</label>
											</td>
											<td>
												<form >
												    <input type="radio" name="timeRadioMulti" checked="checked" value="5"><span class="margin-right-dist">5分钟</span>
													<input type="radio" name="timeRadioMulti" value="10"><span class="margin-right-dist">10分钟</span>
													<input type="radio" name="timeRadioMulti" value="15"><span class="margin-right-dist">15分钟</span>
													<input type="radio" name="timeRadioMulti" value="-1"><span class="margin-right-dist">全部</span>
												</form>
											</td>
										</tr>
									</table>
								</div>
								
								
							</div>
						</div>
								
						<div class="panel panel-info">
		         			<div class="panel-heading">
		         				<h3 class="panel-title">其他</h3>
		         			</div>
		         			<div class="panel-body">
								<div id="video-type-div" class="margin-top-dist">
									<table>
										<tr>
											<td>
												<span>  <span><label style="width:160px;">每个视频优先匹配：</label>
											</td>
											<td>
												<form>
													<input type="radio" name="definitionCheckboxMulti" checked="checked" value="hd"><span class="margin-right-dist">高清</span>
													<input type="radio" name="definitionCheckboxMulti" value="uhd"><span class="margin-right-dist">超高清</span>
													<input type="radio" name="definitionCheckboxMulti" value="sd"><span class="margin-right-dist">标清</span>
												</form>
											</td>
										</tr>
									</table>
								</div>	
								
								<div class="margin-top-dist">
									<div id="choose-node-div" class="margin-top-dist">
										<table>
											<tr>
												<td>
													<label style="width:160px;">测评点：</label>
												</td>
												<td>
													<form id="choose-node-form">
											
													</form>
												</td>
											</tr>
										</table>
									</div>
								</div>
		         			
		         			</div>
		         		</div>
		         	</div><!-- step-1-body-div -->
		         </div>
		         
			        <div class="modal-footer">
				         <button class="button button-rounded" data-dismiss="modal">取消创建</button>
				         <button class="button button-primary button-rounded" id="multi-video-button">确认创建</button>
				    </div>
		      </div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
		
			<!-- 模态框（Modal） -->  <!-- 计划信息模态框 -->
		<div class="modal fade" id="multiInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="localVideoModalLabel">计划信息</h4>
		         </div>
		         <div class="modal-body">
		         	<!-- <div class="input-group">
						   <span class="input-group-addon" style="font-weight:bold">测试视频</span>
						   <input id="video-name-input" type="text" class="form-control"  name="videoname">
					</div>
		         	<div class="input-group">
						   <span class="input-group-addon" style="font-weight:bold">清晰度</span>
						   <input id="video-def-input" type="text" class="form-control"  name="videodef">
					</div> -->
					
					<div id="video-type-div" class="margin-top-dist">
						<label style="width:160px;">测试视频：</label>
						<input id="video-name-input" style="width: 583px" readonly="readonly" type="text" name="videoname"/>
					</div>
					<div id="video-type-div" class="margin-top-dist">
						<label style="width:160px;">清晰度：</label>
						<input id="video-def-input" style="width: 583px" readonly="readonly" type="text" name="videodef"/>
					</div>
					<div id="video-type-div" class="margin-top-dist">
						<label style="width:160px;">包含网站：</label><br>
						<!-- <textarea id="included-web-input" style="margin-left:164px" readonly="readonly" type="text" name="includedweb" rows="10" cols="80"/></textarea> -->
						<div class="table-scroll" style="width:583px;height:176px; margin-left:164px; border: 1px solid #ddd">
							<table class="table table-hover">
								<thead>
									<tr>
										<th>视频网站</th>
										<th>视频地址</th>
									</tr>
								</thead>
								<tbody id="included-web-input">
							
								</tbody>
							</table>
						</div>
							
					</div>
					<div id="video-type-div" class="margin-top-dist">
						<label style="width:160px;">测试周期：</label>
						<input id="test-cycle-input" style="width: 583px" readonly="readonly" type="text" name="testcycle"/>
					</div>
					<div id="video-type-div" class="margin-top-dist">
						<label style="width:160px;">每周开始测量时间：</label>
						<input id="test-week-input" style="width: 583px" readonly="readonly" type="text" name="testweek"/>
					</div>
					<div id="video-type-div" class="margin-top-dist">
						<label style="width:160px;">每天开始测量时间：</label>
						<input id="test-day-input" style="width: 583px" readonly="readonly" type="text" name="testday"/>	
					</div>
					
		         </div>
		      </div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
		
		
		
		
		
		
		<!-- 模态框（Modal） -->
		<div class="modal fade" id="runningDataReportModal" tabindex="-1" role="dialog" aria-labelledby="runningDataModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="runningDataModalLabel">运行时数据</h4>
		         </div>
		         <div class="modal-body">
		         	<div class="panel panel-success">
					   <div class="panel-heading">
							<h3 class="panel-title">测量进度</h3>
					   </div>
					   <div class="panel-body">
				         	<div id="duration-progress-div" style="text-align:center">
				         		<label id="section-label"></label>
				         	   	<span class="margin-right-dist"></span>
				         		<label>分片时长：</label><span id="duration-span"></span>
				         	   	<span class="margin-right-dist"></span>
				         		<label>分片进度：</label><span id="progress-span"></span>
				         	</div>
				         	<div id="pending-msg-div" style="text-align:center">
				         	</div>
					   </div>
					</div>
		         	
		         	<div class="panel panel-info">
					   <div class="panel-heading">
							<h3 class="panel-title">指标数据</h3>
					   </div>
					   <div id="echart-line" class="panel-body" >
					   		<!-- 为 ECharts 准备具备大小（宽高）的Dom -->
				          	<div id="line1" >
								<span id="netbuf-echart" style="width: 400px;height:300px;"></span>
								<span id="videobr-echart" style="width: 480px;height:300px;"></span>
							</div>
							<div id="line2">
								<span id="audiobr-echart" style="width: 480px;height:300px;"></span>
								<span id="framerealrate-echart" style="width: 480px;height:300px;"></span>
							</div>
							<div id="line3">
								<span id="gop-echart" style="width: 480px;height:300px;"></span>
								<span id="framescores-echart" style="width: 480px;height:300px;"></span>
							</div>
							<div id="line4">
								<span id="volume-echart" style="width: 480px;height:300px;"></span>
								<span id="phase-echart" style="width: 480px;height:300px;"></span>
							</div>
							<div id="line5">
								<span id="muteR-echart" style="width: 480px;height:300px;"></span>
								<span id="muteL-echart" style="width: 480px;height:300px;"></span>
							</div>
							<div id="line6">
								<span id="peakR-echart" style="width: 480px;height:300px;"></span>
								<span id="peakL-echart" style="width: 480px;height:300px;"></span>
							</div>
					   </div>
					   <!-- <textarea id="running-data-textarea"  readonly="readonly" class="form-control" rows="10"></textarea> -->
						
						
				</div><!-- /.modal-body -->
			 </div><!-- /.modal-content -->
		   </div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
		</div>
		
		<!-- 模态框（Modal）  创建错误-->
		<div class="modal fade" id="createErrorModal" tabindex="-1" role="dialog" aria-labelledby="createErrorMsgModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="createErrorMsgModalLabel">创建任务失败！</h4>
		         </div>
		         <div class="modal-body">
		         	<div class="panel panel-success">
					   <div class="panel-heading">
							<h3 class="panel-title" id="create-error-msg-h3">错误</h3>
					   </div>
					   <div class="panel-body">
				         	<div id="create-error-msg-div" style="text-align:center">

				         	</div>
					   </div>
					</div>
				</div>
		      </div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
		<!-- 模态框（Modal） 运行错误-->
		<div class="modal fade" id="errorMsgModal" tabindex="-1" role="dialog" aria-labelledby="errorMsgModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="errorMsgModalLabel">运行错误</h4>
		         </div>
		         <div class="modal-body">
		         	<div class="panel panel-success">
					   <div class="panel-heading">
							<h3 class="panel-title" id="error-msg-h3">错误</h3>
					   </div>
					   <div class="panel-body">
				         	<div id="error-msg-div" style="text-align:center">

				         	</div>
					   </div>
					</div>
				</div>
		      </div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
		<!-- 模态框（Modal）--> 
		<div class="modal fade" id="restartTaskModal" tabindex="-1" role="dialog" aria-labelledby="restartTaskModalLabel" aria-hidden="true">
			<div class="modal-dialog" style="width:550px;" >
				<div class="modal-content">
					<div class="modal-header">
		            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            	<h4 class="modal-title" id="restartTaskModalLabel">重新测量</h4>
					</div>
					<div class="modal-body">
						<div class="panel panel-success">
						<div class="panel-heading">
							<h4 class="panel-title">任务信息</h4>
						</div>
						<div class="panel-body">
							<input id="hidden-restarttask-jobid" type="hidden" value="0">
							<div id="task-info-div">
							
							</div>
						</div>
					</div>
					</div>
					<div class="modal-footer">
			            <button class="button button-rounded button-small" data-dismiss="modal">取消创建</button>
			            <button class="button button-rounded button-small button-primary" id="restart-task-button">确认重启</button>
				    </div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
		<!-- 批量视频重启 模态框（Modal）777 --> 
		<div class="modal fade" id="restartMultiTaskModal" tabindex="-1" role="dialog" aria-labelledby="restartMultiTaskModalLabel" aria-hidden="true">
			<div class="modal-dialog" style="width:550px;" >
				<div class="modal-content">
					<div class="modal-header">
		            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            	<h4 class="modal-title" id="restartMultiTaskModalLabel">重新测量</h4>
					</div>
					<div class="modal-body">
						<div class="panel panel-success">
						<div class="panel-heading">
							<h4 class="panel-title">任务信息</h4>
						</div>
						<div class="panel-body">
							<input id="hidden-restartmultitask-jobid" type="hidden" value="0">
							<div id="task-multi-info-div">
							
							</div>
						</div>
					</div>
					</div>
					<div class="modal-footer">
			            <button class="button button-rounded button-small" data-dismiss="modal">取消创建</button>
			            <button class="button button-rounded button-small button-primary" id="restart-multi-task-button">确认重启</button>
				    </div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal -->
		</div>
		
	</div>
</body>
</html>
<!-- out.print("<script type='text/javaScript'>alert('你要弹出的消息在这里写。');window.location.reload;</script>"); -->