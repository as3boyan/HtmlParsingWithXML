package ;

import haxe.xml.Fast;
import js.Lib;
import js.Node;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	static function main() 
	{
		var options = {
		  host: 'lib.haxe.org',
		  port: 80,
		  path: '/all'
		};

		var emitter = Node.http.get(options, function(res) {
		  trace("Got response: " + res.statusCode);
		  
		  res.setEncoding(NodeC.UTF8);
		  
		  var data:String = "";
		  
		  res.on('data', function (chunk:String):Void 
		  {
			  data += chunk;
		  });
		  
		  res.on('end', function ():Void 
		  {
			  var libs = parseHtml(data);
			  trace(libs);
		  });
		  
		});
		
		emitter.on('error', function(e) {
		  trace("Got error: " + e.message);
		});
		
		Node.process.stdin.resume();
	}
	
	static function parseHtml(data:String):Array<String>
	{
		var libs:Array<String> = [];
		
		var xml = Xml.parse(data);
		var fast = new Fast(xml);
		
		if (fast.hasNode.html) 
		{
			var html:Fast = fast.node.html;
			
			if (html.hasNode.body) 
			{
				var body:Fast = html.node.body;
				
				if (body.hasNode.div) 
				{				
					for (node in body.nodes.div) 
					{			
						if (node.has.resolve("class") && node.att.resolve("class") == "page") 
						{
							for (div in node.nodes.div) 
							{
								if (div.has.resolve("class") && div.att.resolve("class") == "content")
								{									
									for (div2 in div.nodes.div) 
									{
										if (div2.has.resolve("class") && div2.att.resolve("class") == "projects")
										{
											if (div2.hasNode.ul) 
											{
												var ul = div2.node.ul;
												
												for (li in ul.nodes.li) 
												{
													libs.push(li.node.a.innerData);
													
													if (li.hasNode.div) 
													{
														var descriptionDiv = li.node.div;
														
														if (descriptionDiv.att.resolve("class") == "description") 
														{		
															try 
															{
																trace(li.node.a.innerData);
																trace(descriptionDiv.innerData);
															}
															catch (unknown:Dynamic)
															{
																trace(unknown);
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		return libs;
	}
	
}