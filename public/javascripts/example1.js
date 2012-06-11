nodeArray=new Array();

var labelType, useGradients, nativeTextSupport, animate;



//Added to have a roundish rectangle
$jit.ST.Plot.NodeTypes.implement({
        'roundrect': {
          'render': function(node, canvas, animating) {
                  var pos = node.pos.getc(true), nconfig = this.node,
data = node.data;
                  var width  = nconfig.width, height = nconfig.height;
                  var algnPos = this.getAlignedPos(pos, width,
height);
                  var ctx = canvas.getCtx(), ort =
this.config.orientation;
                  ctx.beginPath();

                        var r = 10; //corner radius
                        var x = algnPos.x;
                        var y = algnPos.y;
                        var h = height;
                        var w = width;

                        ctx.moveTo(x + r, y);
                        ctx.lineTo(x + w - r, y);
                        ctx.quadraticCurveTo(x + w, y, x + w, y + r);
                        ctx.lineTo(x + w, y + h - r);
                        ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
                        ctx.lineTo(x + r, y + h);
                        ctx.quadraticCurveTo(x, y + h, x, y + h - r);
                        ctx.lineTo(x, y + r);
                        ctx.quadraticCurveTo(x, y, x + r, y);
                        ctx.fill();
          }
        }
    }); 

//End of roundish rectangle code
(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
  
  
  
})();


var Log = {
  elem: false,
  write: function(text){
    if (!this.elem) 
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};


function drawGraph(){
    //init data
   //var jsonStr=jsonString;
   // alert(jsonString);
   
   var jsonStr=jQuery.parseJSON(jsonString);
   
   //alert("Drawing");
    
  
    //end
    //init Spacetree
    //Create a new ST instance
    
    var st = new $jit.ST({
        //id of viz container element
        injectInto: 'infovis',
        
        width: canvasWidth,
        height: canvasHeight,
        
        multitree: false,
        siblingOffset:75,
        orientation: "top",
        align: "center",
        
        //set duration for the animation
        duration: animDuration,
        //set animation transition type
        transition: $jit.Trans.Quart.easeInOut,
        //set distance between node and its children
        levelDistance: 90,
                            
        //enable panning
        Navigation: {
          enable: true,
          panning: true,
          //zooming: 20
        },
        
         //set node and edge styles
        //set overridable=true for styling individual
        //nodes or edges
        
        Node: {
            type: 'circle',
            color: '#F27713',
            width :80,
            height :50,
            dim :80,
            overridable: true,
            contenteditable: true,
            align: 'center',
            //border: 'solid',
            
        },
        
        Edge: {
            type: 'line',
            overridable: true
        },
        
        onBeforeCompute: function(node){
        	Log.write("loading " + node.name);
               	
        },
        
        onComplete: function(){
        	
        },
        
        onAfterCompute: function(){
           findOnPage(nodeArray);
        },
        
        //This method is called on DOM label creation.
        //Use this method to add event handlers and styles to
        //your node.
        onCreateLabel: function(label, node){
        	
        	nodeArray.push(node);
        	
            label.id = node.id;
            label.onmouseover =function()
            {
            	if(c2Collapse==0 && c1Collapse==0)
                 {
                   for(var i=0;i<obj.length;i++)
                   {
                   	if(node.id==obj[i].category.id)
                   	{
                   		jQuery("#tip").html(obj[i].category.description);
                   		jQuery("#tip").slideDown(1000,"easeOutBack");
			        }
			       } 
            	 }
            };
            
            label.onmouseout=function(){
            	jQuery("#tip").slideUp(1000,"easeOutBack");
            };
            
            //label.title=modifyTitle(label);
            label.innerHTML = node.name;
            label.onclick = function(){
            	if(normal.checked) {
            	st.onClick(node.id);
            	//st.onMouseEnter(node.id);
            	//drawArc(node);
            	//alert("XRFGF");
            	showDescription(node.id);
            	} else {
                st.setRoot(node.id, 'animate');
                //drawArc(node);
                showDescription(node.id);
            	}
            	
            };
            //set label styles
            var style = label.style;
                       
            style.cursor = 'pointer';
            style.color = '#FFF';
            style.fontSize = '1.0 em';
            style.textAlign= 'center';
            style.width = 80 + 'px';
            style.height = 20 + 'px'; 
            style.contenteditable= 'true';
            style.textBaseline= 'alphabetic';
                                   
        },
        
        //This method is called right before plotting
        //a node. It's useful for changing an individual node
        //style properties before plotting it.
        //The data properties prefixed with a dollar
        //sign will override the global node style properties.
        onBeforePlotNode: function(node){
            //add some color to the nodes in the path between the
            //root node and the selected node.
            for(var i=0;i<obj.length;i++)
    		{
       			if(obj[i].category.id==node.id)
       			{
       				//alert(obj[i].category.blueprint.color);
           				node.data.$type=obj[i].category.blueprint.node_type;
           				node.data.$color=obj[i].category.blueprint.color; 
           				node.data.$height=50;
           				node.data.$width=80;  
           				      
            	}
            }
            
            
            if (node.selected) {
            	
            	node.data.$color = "#30C117";
            
                //drawArc(node);
            }
            else {
            	
                //delete node.data.$color;
                //if the node belongs to the last plotted level
                if(!node.anySubnode("exist")) {
                    //count children number
                    var count = 0;
                    node.eachSubnode(function(n) { count++; });
                    //assign a node color based on
                    //how many children it has
                    //node.data.$color = ['#aaa', '#baa', '#caa', '#daa', '#eaa', '#faa','#f88','#f77','#f66','#f44','#f33','#f11','#f00'][count];                    
                }
            }
        },
        
        //This method is called right before plotting
        //an edge. It's useful for changing an individual edge
        //style properties before plotting it.
        //Edge data proprties prefixed with a dollar sign will
        //override the Edge global style properties.
        onBeforePlotLine: function(adj){
            if (adj.nodeFrom.selected && adj.nodeTo.selected) {
                adj.data.$color = "#1756EA";
                adj.data.$lineWidth = 3;
            }
            else {
                delete adj.data.$color;
                adj.data.$lineWidth =2;
            }
        }
    });
    
    //load json data
    st.loadJSON(jsonStr);
    //compute node positions and layout
    st.compute();
    //optional: make a translation of the tree
    st.geom.translate(new $jit.Complex(0, 0), "current");
    //emulate a click on the root node.
    
    if(selectedNode==null)   
    {
    	st.onClick(st.root)
    	{
    	setRootNode=false;
    	};
    }
    else
    {
    st.onClick(st.root,{onComplete: function(){st.onClick(selectedNode); }})
    {
    	setRootNode=false;
    };
    }
    //end
    //Add event handlers to switch spacetree orientation.
    var top = $jit.id('r-top'); 
        left = $jit.id('r-left'), 
        bottom = $jit.id('r-bottom'), 
        right = $jit.id('r-right'),
        normal = $jit.id('s-normal');
        
        
        
    
    function changeHandler() {
        if(this.checked) {
            top.disabled = bottom.disabled = right.disabled = left.disabled = true;
            st.switchPosition(this.value, "animate", {
                onComplete: function(){
                	top.disabled = bottom.disabled = right.disabled = left.disabled = false;
                }
            });
        }
    };
    
    top.onchange = left.onchange = bottom.onchange = right.onchange = changeHandler;
    //end

 
 
}

function showDescription(node_id)
  {
  	showProgress(node_id);
    for(var i=0;i<obj.length;i++)
    {
       	if(obj[i].category.id==node_id)
       	{
        	$j("#panel3").html('<div class="descName">'+obj[i].category.name+'</div>');
          	$j("#panel3").append('</br>');
          	$j("#panel3").append(obj[i].category.description);	
        }
    }
  }
	              
function showProgress(node_id)
{
	$j.post("progress_done",{id : node_id});
	selectedNode=node_id;
	
}

function findOnPage(nodeArray)
{
	
	for(var j=0;j<nodeArray.length;j++)
	{
		var visibleNode= $j("#"+nodeArray[j].id);
		if(!(visibleNode.is(':hidden')))
		{
			drawArc(nodeArray[j]);
		}
	}
}
function drawArc(point)
{
	var position= point.getPos("current");
	var canvas=document.getElementById("infovis-canvas");
	var ctx=canvas.getContext('2d');
	switch(point.data.$type)
	{
		case "circle":
		drawCircle(point, ctx, position);
		break;
		case "rectangle":
		drawRectangle(point, ctx, position);		
		break;
		case "roundrect":
		drawRoundRect(point,ctx,position);		
		break;
		default:
		//alert("Cant explain which shape it is!!");
		
	}
}
function drawCircle(point, ctx, position)
{
	ctx.beginPath();
	var radius=37;
	var startAngle=270*(Math.PI/180);
	var endAngle=end(point);
	ctx.arc(position.x,position.y,radius,startAngle,endAngle);
	ctx.strokeStyle="#FFF";
	ctx.lineWidth=2;
	ctx.stroke();
}
function drawRectangle(point, ctx, position)
{
	var height=point.data.$height- 8;
    var width=point.data.$width- 8;
    var perimeter= 2*(height+width);
    var progress=0;
    for(i=0;i<obj.length;i++)
		   {
		   	if(obj[i].category.id==point.id)
		   	{
		   		progress=obj[i].category.progress;	
		   	}
	}
    var availablePeri=perimeter*progress/100;
    //alert(availablePeri);
    
    //alert(position.x)
    ctx.moveTo(position.x, (position.y - height/2));
    if(availablePeri!=0)
    {
    if(availablePeri>width/2)//level 1
       {
       	ctx.lineTo(position.x+width/2, (position.y-height/2));
       	availablePeri-=width/2;
       //	alert(availablePeri);
       	//alert("Greater");
       	if(availablePeri > height)//level 2
       		{
       			ctx.lineTo(position.x+width/2, (position.y -height/2)+height)
       			availablePeri-=height;
       			if(availablePeri> width)// level 3
       				{
       				    ctx.lineTo(position.x-width/2 ,position.y+height/2);
       				    availablePeri-=width;
       				    if(availablePeri>height)// level 4
       				    {
       				    	ctx.lineTo(position.x-width/2, position.y-height/2)
       				    	availablePeri-= height
       				    	//alert(availablePeri);
       				    	ctx.lineTo(position.x-(width/2- availablePeri), position.y-height/2);       				    	
       				    }
       				    else
       				    {
       				    	ctx.lineTo(position.x-width/2, position.y+(height/2-availablePeri))
       				    }
       				}
       			else
       				{
       					ctx.lineTo(position.x+(width/2-availablePeri),(position.y+height/2))
       				}
       		}
       	else
       	{
       	   ctx.lineTo(position.x+width/2, (position.y - height/2)+availablePeri)	
       	}	
       }
    else
       {
       	ctx.lineTo(position.x+availablePeri, (position.y- height/2));
      // 	alert("Lesser");
       }
    
    }
    ctx.stroke();	
}

function drawRoundRect(point, ctx, position)
{
	var height=point.data.$height- 8;
    var width=point.data.$width- 8;
    var perimeter= 2*(height+width);
    var progress=0;
    for(i=0;i<obj.length;i++)
		   {
		   	if(obj[i].category.id==point.id)
		   	{
		   		progress=obj[i].category.progress;	
		   	}
	}
    var availablePeri=perimeter*progress/100;
    //alert(availablePeri);
    
    //alert(position.x)
    ctx.moveTo(position.x, (position.y - height/2));
    if(availablePeri!=0)
    {
    if(availablePeri>width/2)//level 1
       {
       	ctx.lineTo(position.x+width/2, (position.y-height/2));
       	availablePeri-=width/2;
       //	alert(availablePeri);
       	//alert("Greater");
       	if(availablePeri > height)//level 2
       		{
       			ctx.lineTo(position.x+width/2, (position.y -height/2)+height)
       			availablePeri-=height;
       			if(availablePeri> width)// level 3
       				{
       				    ctx.lineTo(position.x-width/2 ,position.y+height/2);
       				    availablePeri-=width;
       				    if(availablePeri>height)// level 4
       				    {
       				    	ctx.lineTo(position.x-width/2, position.y-height/2)
       				    	availablePeri-= height
       				    	//alert(availablePeri);
       				    	ctx.lineTo(position.x-(width/2- availablePeri), position.y-height/2);       				    	
       				    }
       				    else
       				    {
       				    	ctx.lineTo(position.x-width/2, position.y+(height/2-availablePeri))
       				    }
       				}
       			else
       				{
       					ctx.lineTo(position.x+(width/2-availablePeri),(position.y+height/2))
       				}
       		}
       	else
       	{
       	   ctx.lineTo(position.x+width/2, (position.y - height/2)+availablePeri)	
       	}	
       }
    else
       {
       	ctx.lineTo(position.x+availablePeri, (position.y- height/2));
      // 	alert("Lesser");
       }
    
    }
    ctx.stroke();	
}

function end(point)
{
	var endAngle;
	for(i=0;i<obj.length;i++)
		   {
		   	if(obj[i].category.id==point.id)
		   	{
		   		
		   		endAngle=(360*obj[i].category.progress/100);
		   		endAngle=endAngle+270;
		   		//alert(endAngle);
		   		if(endAngle>360)
		   		{
		   		//alert(obj[i].category.name+" "+endAngle);
		   		//alert("in here");
		   		endAngle=endAngle-360;
		   		if(endAngle==270)
		   		endAngle-=0.001;
		   		}
		   		if(navigator.appName=="Microsoft Internet Explorer")
		   		{
		   			if(endAngle==0)
		   			endAngle=0.001;
		   		}
		   		//alert(endAngle);
		   		return (endAngle*(Math.PI/180));
		   	}
	   }
}

function goToLastSelected()
{
	nodeHistory.push(selectedNode);
	findParent();
}

function findParent()
{
	//alert(selectedNode);
	var parent_id;
	for(var i=0;i<obj.length;i++)
	{
		if(obj[i].category.id==selectedNode)
		parent_id=obj[i].category.parent_id;
	}
	selectedNode=parent_id;
	//alert(selectedNode);
	//alert("Parent ID"+parent_id);
	nodeHistory.push(parent_id);
	if(selectedNode!=null)
	findParent();
}

function saveCanvas()
{
	canvasHeight=1000;
	canvasWidth=1000;
	animDuration=0;
	var jxhr=jQuery.get("show_graph",function(data){jQuery("#desktop").html(data)})
	
	
	var temp=setTimeout("abc()",3000);
	
	
}
function abc()
{
	var canvas=document.getElementById("infovis-canvas");
	var context=canvas.getContext("2d");
    context.fillStyle="white";
	context.font="12px Helvetica";
	for(var i=0;i<nodeArray.length;i++)
	{
	   var position= nodeArray[i].getPos("current");
	   context.fillText(nodeArray[i].name,position.x-40,position.y);
	}
	var img=canvas.toDataURL("image/png");
	document.write('<img src="'+img+'"/>');
}




