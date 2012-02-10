--- yaml
layout: 'article'
title: 'By example: Continuation-passing style in JavaScript'
author: 'Yongjae Choi'
date: '2012-02-09'
tags: ['javascript', 'CPS', 'programming']
---

//예제로 설명하는 자바스크립트에서의 Continusation-passing style

Continuation-passing style (CPS) originated as a style of programming in the 1970s, and it rose to prominence as an intermediate representation for compilers of advanced programming languages in the 1980s and 1990s.
Continuation-passing style(이하 CPS)은 1970년대에 프로그래밍 스타일의 하나로 생겨나고, 1980, 1990년대에 고급 프로그래밍 언어 컴파일러의 중간 표현으로써 각광받았다.

It's now being rediscovered as a style of programming for non-blocking (usually distributed) systems.
이제 이 프로그래밍 스타일은 논 블로킹 시스템(그리고 보통 분산 시스템)에서 다시 조명받고 있다.


There's a warm spot in my heart for CPS, because it was the secret weapon in my Ph.D. It probably shaved off a couple years and immeasurable agony.
내가 박사 과정일때에 CPS는 비밀무기였다. 그래서 난 CPS를 좋아한다. 아마 덕분에 난 2년정도를 아낄 수 있었고, 끝없는 고통에서 벗어날 수 있었다.


This article introduces CPS in both of its roles--as a style for non-blocking programming in JavaScript, and (briefly) as an intermediate form for a function l language.
이 글은 자바스크립트에서의 논블로킹 프로그래밍 스타일로써의 CPS와 함수형 언어의 중간 형태로써의 CPS, 두 가지 관점에서 CPS를 소개하는 글이다.


Topics covered:
아래의 이야기를 할 것이다.

 * 자바스크립트에서의 CPS CPS in JavaScript
 * Ajax 프로그래밍을 위한 CPS CPS for Ajax programming
 * (node.js에서) 논 블로킹 프로그래밍을 위한 CPS CPS for non-blocking programming (in node.js)
 * 분산 프로그래밍을 위한 CPS CPS for distributed programming
 * CPS를 이용해서 예외 처리 하는 방법 How to implement exceptions using CPS
 * 미니말 Lisp을 위한 CPS 컨버터 A CPS converter for a minimal Lisp
 * 리습에서 call/cc 구현하는 방법 How to implement call/cc in Lisp
 * 자바스크립트에서 call/cc 구현하는 방법 How to implement call/cc in JavaScript

Read on for more.


# What is continuation-passing style?
# Continuation-passing style이 뭐야?

If a language supports continuations, the programmer can add control constructs like exceptions, backtracking, threads and generators.
만약 언어가 continuation을 지원한다면, 프로그래머는 예외나 백트래킹이나 스레드, 제네레이터등의 제어 구조를 추가할 수 있다.


Sadly, many explanations of continuations (mine included) feel vague and unsatisfying. Such power deserves a solid pedagogical foundation.
슬프게도 continuation에 대한 많은 설명들은 막연하고 불충분한것 같다.  그런 것들은 더 탄탄한 교수법적인 기초를 다져야 한다.


Continuation-passing style is that foundation.
Continuation-passing 스타일이 바로 그 기초이다.

Continuation-passing style gives continuations meaning in terms of code.
Continuation-passing 스타일은 코드에 continuation의 의미를 부여한다.

Even better, a programmer can discover continuation-passing style by themselves if subjected to one constraint:
오히려, 하나의 제약 사항만 지킨다면 프로그래머는 continuation-passing 스타일을 스스로 발견할 수 있다.


No procedure is allowed to return to its caller--ever.
어떠한 프로시저도 caller로 리턴되지 않는다.


아래 힌트는 이러한 스타일로 프로그래밍 하는데 도움이 된다.

Procedures can take a callback to invoke upon their return value.
프로시저는 그들의 리턴 값으로 호출 가능한 콜백을 가질 수 있다.


When a procedure is ready to "return" to its caller, it invokes the "current continuation" callback (provided by its caller) on the return value.
프로시저가 caller로 리턴할 준비가 되었을때, 프로시저는 "현재 continuation" 콜백을 리턴 값으로 호출한다. (이 콜백은 caller에서 왔다)


A continuation is a first-class return point.
continuation은 일차 리턴 포인트이다.

## Example: Identity function 예제: 동일 함수
## Consider the identity function written normally:

동일 함수가 일반적으로 작성되었다고 가정하자.

	function id(x) {
	  return x ;
	}


and then in continuation-passing style:
그리고 continuation-passing 스타일로는 다음과 같이 쓴다:

	function id(x,cc) {
	  cc(x) ;
	}

Sometimes, calling the current continuation argument ret makes its purpose more obvious:
가끔 현재 continuation 인자를 ret으로 하는 것은 코드를 좀 더 명확하게 해준다.

	function id(x,ret) {
	  ret(x) ;
	}

## Example: Naive factorial
## 예제: 단순무식한 팩토리얼

Here's the standard naive factorial:
아래는 표준형의 단순무식한 팩토리얼이다:

	function fact(n) {
	  if(n == 0)
		return 1 ;
	  else
		return n * fact(n-1) ;
	}

Here it is in CPS:
그리고 CPS로는 다음과 같다.

	function fact(n,ret) {
	  if(n == 0)
		ret(1) ;
	  else
		fact(n-1,function(t0) {
		 ret(n * t0) }) ;
	}

And, to "use" the function  we pass it a callback:
그리고 함수 사용하기. 콜백을 넘겨줬다.

	fact (5,function(n) {
	  console.log(n) ;// Prints 120 in Firebug.
	})

## Example: Tail-recursive factorial
## 예제: Tail-recursive 팩토리얼

Here's tail-recursive factorial:
아래는 tail-recursive 팩토리얼의 구현이다.

	function fact(n) {
	  return tail_fact(n,1) ;
	}
	 
	function tail_fact(n,a) {
	  if(n == 0)
		return a ;
	  else
		return tail_fact(n-1,n*a) ;
	}

And, in CPS:
그리고 아래는 CPS로 구현한 것이다.

	function fact(n,ret) {
	  tail_fact(n,1,ret) ;
	}
	 
	function tail_fact(n,a,ret) {
	  if(n == 0)
		ret(a) ;
	  else
		tail_fact(n-1,n*a,ret) ;
	}

# CPS and Ajax 
# CPS와 Ajax

Ajax is a web programming technique which uses an XMLHttpRequest object in JavaScript to fetch data (asynchronously) from a server.
Ajax는 자바스크립트의 XMLHttpRequest 객체를 이용해 비동기적으로 서버에서 데이터를 가져오는 웹 프로그래밍 기술이다.


(That data need not be XML.)
(근데 데이터는 꼭 XML일 필요는 없다)

CPS provides an elegant way to do Ajax programming.
CPS는 ajax 프로그래밍을 하기에 우아한 방법을 제공한다.

With XMLHttpRequest, we could write a blocking procedure fetch(url) that grabs the contents of a url as a string, and then returns it.
XMLHttpRequest를 이용하면 블로킹 프로시저인 fetch(url)을 작성할 수 있다. 이 프로시저는 url이 가리키는 페이지의 내용을 문자열 변수에 담아 리턴한다.

The problem with this approach is that JavaScript is a single-threaded language, and when JavaScript blocks, the browser is momentarily frozen.
이런 방식의 문제는 자바스크립트가 단일 스레드만 지원하는 언어라는 점이다. 자바스크립트가 블럭되면 브라우저가 그 블럭되어 있는 동안 멈춘다.

It makes for an unpleasant user experience.
그러면 사용자 경험이 망가진다.

A better approach is a procedure fetch(url,callback) which allows execution (or browser rendering) to continue, and calls the provided callback once the request is completed.
더 나은 방식은 프로시저를 fetch(url, callback)으로 만드는 것이다. 이 프로시저는 코드 실행이나 브라우저 랜더링을 계속 하도록 블로킹 되지 않는다. 요청이 끝나면 호출할 콜백을 넘겨준다.

In this approach, partial CPS-conversion becomes a natural way to code.
이 방식에서 부분적인 CPS전환은 코딩을 하는 자연스러운 방법이다.

## Implementing fetch
## fetch 구현

It's not hard to implement fetch so that it operates in non-blocking mode or blocking mode, depending on whether the programmer supplied a callback:
 콜백 제공 여부에 따라 논블러킹 모드나 블러킹 모드의 Fetch 를 구현하는 것은 어렵지 않다. 그건 다르다.


	/*
	 fetch is an optionally-blocking
	 procedure for client->server requests.
	 
	 If only a url is given, the procedure
	 blocks and returns the contents of the url.
	 
	 If an onSuccess callback is provided,
	 the procedure is non-blocking, and the
	 callback is invoked with the contents
	 of the file.
	 
	 If an onFail callback is also provided,
	 the procedure calls onFail in the event of
	 a failure.
	 
	*/
	 
	function etch (url, onSuccess, onFail) {
	 
	  // Async only if a callback is defined:
	  varasync = onSuccess ?true:false;
	  // (Don't complain about the inefficiency
	  //  of this line; you're missing the point.)
	 
	  varreq ;// XMLHttpRequest object.
	 
	  // The XMLHttpRequest callback:
	  function rocessReqChange() {
		if(req.readyState == 4) {
		  if(req.status == 200) {
			if(onSuccess)
			  onSuccess(req.responseText, url, req) ;
		  }else{
			if(onFail)
			  onFail(url, req) ;
		  }
		}
	  }
	 
	  // Create the XMLHttpRequest object:
	  if(window.XMLHttpRequest)
		req =newXMLHttpRequest();
	  elseif(window.ActiveXObject)
		req =newActiveXObject("Microsoft.XMLHTTP");
	 
	  // If asynchronous, set the callback:
	  if(async)
		req.onreadystatechange = processReqChange;
	 
	  // Fire off the request:
	  req.open("GET", url, async);
	  req.send(null);
	 
	  // If asynchronous,
	  //  return request object; or else
	  //  return the response.
	  if(async)
		return req ;
	  else
		return req.responseText ;
	}


## Example: Fetching data
## 예제: 데이터 가져오기

Consider a program that needs to grab a name for a UID.
UID의 이름을 가져오는 프로그램이 있다고 가정하자.


Using fetch, both of the following work:
fetch를 이용해서 두 버전을 다 만든다.

	// Blocks until request in finished:
	varsomeName = fetch("./1031/name") ;
	 
	document.write ("someName: "+ someName +"<br>") ;
	 
	// Does not block:
	fetch("./1030/name",function(name) {
	 document.getElementById("name").innerHTML = name ;
	}) ;


(See the example.)

# CPS and non-blocking programming 
# CPS와 논 블로킹 프로그래밍

node.js is a high-performance, server-side platform for JavaScript in which blocking procedures are banned.
node.js는 블로킹 프로시저가 없는 자바스크립트를 위한 고성능, 서버사이드 플랫폼이다. 

Cleverly, procedures which ordinarily would block (e.g. network or file I/O) take a callback that to be invoked with the result.
똑똑하게도 보통의 블로킹되는 프로시저들은 콜백을 받아서 결과로써 콜백을 실행하게 되어있다.

Partially CPS-converting a program makes for natural node.js programming.
부분적으로 프로그램을 CPS 변환하는 것이 node.js 프로그래밍 다운 프로그래밍이다.

## Example: Simple web server
## 예제 : 간단한 웹 서버

A simple web server in node.js passes a continuation to the file-reading procedure. Compared to the select-based approach to non-blocking IO, CPS makes non-blocking I/O straightforward.
node.js로 만드는 간단한 웹 서버에는 파일을 읽는 프로시저로 continuation을 넘기는 부분이 있다. select를 이용한 논 블러킹 IO에 비해 CPS를 이용한 논 블로킹 IO가 간단하다.

	varsys = require('sys') ;
	varhttp = require('http') ;
	varurl = require('url') ;
	varfs = require('fs') ;
	 
	// Web server root:
	varDocRoot ="./www/";
	 
	// Create the web server with a handler callback:
	varhttpd = http.createServer(function(req, res) {
	  sys.puts(" request: "+ req.url) ;
	 
	  // Parse the url:
	  varu = url.parse(req.url,true) ;
	  varpath = u.pathname.split("/") ;
	 
	  // Strip out .. in the path:
	  varlocalPath = u.pathname ;
	  //  "<dir>/.." => ""
	  varlocalPath =
		  localPath.replace(/[^/]+\/+[.][.]/g,"") ;
	  //  ".." => "."
	  varlocalPath = DocRoot + 
					  localPath.replace(/[.][.]/g,".") ;
	 
	  sys.puts(" local path: "+ localPath) ;
	   
	  // Read in the requested file, and send it back.
	  // Note: readFile takes the current continuation:
	  fs.readFile(localPath,function(err,data) {
		varheaders = {} ;
	 
		if(err) {
		  headers["Content-Type"] ="text/plain";
		  res.writeHead(404, headers);
		  res.write("404 File Not Found\n") ;
		  res.end() ; 
		}else{
		  varmimetype = MIMEType(u.pathname) ;
	 
		  // If we can't find a content type,
		  // let the client guess.
		  if(mimetype)
			headers["Content-Type"] = mimetype ;
	 
		  res.writeHead(200, headers) ;
		  res.write(data) ;
		  res.end() ;  
		}
	   }) ;
	}) ;
	 
	// Map extensions to MIME Types:
	varMIMETypes = {
	 "html":"text/html",
	 "js"   :"text/javascript",
	 "css"  :"text/css",
	 "txt"  :"text/plain"
	} ;
	 
	function IMEType(filename) {
	 varparsed = filename.match(/[.](.*)$/) ;
	 if(!parsed)
	   return false;
	 varext = parsed[1] ;
	 return MIMEType[ext] ;
	}
	 
	// Start the server, listening to port 8000:
	httpd.listen(8000) ;


# CPS for distributed computation
# 분산 컴퓨팅을 위한 CPS

CPS eases factoring a computation into local and distributed portions.
CPS 


Suppose you wrote the combinatorial choose function  first normally:
조합의 선택 함수를 작성했다고 가정하자. 우선 일반적인 방법.

	function choose (n,k) {
	   return fact(n) /
		  (fact(k) * fact(n-k)) ;  
	}

Now, suppose you want to compute factorial on a server, instead of locally.
이제 이 코드가 로컬 컴퓨터가 아닌 서버에서 동작하기를 바란다고 하자.

You could rewrite fact to block and wait for the server to respond.
우리는 fact 프로시저를 서버에서 블럭되어 응답이 오기까지 기다리도록 재작성 할 수 있다.

That's bad.
이거 나쁘다 

Instead, assume you wrote choose in CPS:
대신 CPS로 choose를 작성한다고 해보자.

	function choose(n,k,ret) {
	  fact (n,  function(factn) {
	  fact (n-k,function(factnk) {
	  fact (k,  function(factk) {
	  ret  (factn / (factnk * factk)) }) }) })
	}

Now, it's straightforward to redefine fact to asynchronously compute factorial on the server:
이제 fact 프로시저가 비동기적으로 팩토리얼을 계산할 수 있도록 만들기가 쉬워졌다.

	function fact(n,ret) {
	 fetch ("./fact/"+ n,function(res) {
	   ret(eval(res))
	 }) ;
	}


(Fun exercise: modify the node.js server so that this works.)
(재미있는 연습: 이 코드가 동작하도록 node.js를 변경해보세요.)

# Implementing exceptions in CPS
# CPS로 예외 처리 하기

Once a program is in CPS, it breaks the standard exception mechanisms in the language. Fortunately, it's easy to implement exceptions in CPS.
프로그램이 CPS로 작성되면, 그 언어의 표준적인 예외 처리 매커니즘은 쓸모없어진다. 다행히도 CPS에서 예외처리를 구연하는 것은 어렵지 않다.

An exception is a special case of a continuation.
예외 처리는 continuation의 특수한 케이스이다.

By passing the current exceptional continuation alongside the current continuation, one can desugar try/catch blocks.
현재 예외적 continuation을 현재 continuation과 함께 던이는 것은 try/catch 구문을 없앨 수 있다.

Consider the following example, which uses exceptions to define a "total" version of factorial:
다음 예제를 보면 팩토리얼의 "total"버전을 정의할 때 exeption을 이용하고 있다.

	function fact (n) {
	  if(n < 0)
		throw"n < 0";
	  elseif(n == 0)
		return 1 ;
	  else
		return n * fact(n-1) ;
	}
	 
	function total_fact (n) {
	  try{
		return fact(n) ;
	  }catch(ex) {
		return false;
	  }
	}
	 
	document.write("total_fact(10): "+ total_fact(10)) ;
	document.write("total_fact(-1): "+ total_fact(-1)) ;

By adding an exceptional continuation in CPS, we can desugar the throw, try and catch:
CPS에서 예외적 continuation을 추가해서, throw, try, catch 를 제거할 수 있다.

	function fact (n,ret,thro) {
	 if(n < 0)
	   thro("n < 0");
	 else if(n == 0)
	   ret(1);
	 else
	   fact(n-1,
		function(t0) {
		  ret(n*t0);
		},
		thro);
	}
	 
	function total_fact (n,ret) {
	  fact (n,ret,
		function(ex) {
		  ret(false);
		});
	}
	 
	total_fact(10,function(res) {
	  document.write("total_fact(10): "+ res);
	});
	 
	total_fact(-1,function(res) {
	  document.write("total_fact(-1): "+ res);
	});


# CPS for compilation
# 컴파일을 위한 CPS

For three decades, CPS has been a powerful intermediate representation for compilers of functional programming languages.
30년간 CPS는 함수형 언어 컴파일러가 사용하는 강력한 중간 표현식이었다.

CPS desugars function return, exceptions and first-class continuations; function call turns into a single jump instruction.
CPS는 함수의 리턴, 예외, 일차 continuation을 제거한다. 함수 호출은 그냥 하나의 점프 명령어로 변한다.

In other words, CPS does a lot of the heavy lifting in compilation.
다시 말해서, CPS는 컴파일에서 많은 것을 들어내는 데에 사용된다.

## Translating the lambda calculus to CPS
## 람다 계산법을 CPS로 바꾸기

The lambda calculus is a miniature Lisp, with just enough expressions (applications, anonymous function  and variable references) to make it universal for computation:
람다 계산법은 보편적인 계산을 하기에 충분한 표현식(어플리케이션, 익명함수 변수 레퍼런스)을 가진 Lisp의 축소판이다. 


	exp ::= (expexp)           ; 함수 어플리케이션 function application
		  |  (lambda (var) exp)  ; 익명 함수 anonymous function
		  |  var                 ; 변수 레퍼런스 variable reference

The following Racket code converts this language into CPS:
다음 라켓 코드는 이 언어를 CPS로 바꾼다. 

	(define (cps-convert term cont)
	  (match term
		[`(,f ,e)
		 ; =>
		 (let (($f (gensym 'f))
			   ($e (gensym 'e)))
		   (cps-convert f `(lambda (,$f)
			 ,(cps-convert e `(lambda (,$e)
				 (,$f ,$e ,cont))))))]
		
		[`(lambda (,v) ,e)
		 ; =>
		 (let (($k (gensym 'k)))
		   `(,cont (lambda (,v ,$k)
					 ,(cps-convert e $k))))]
		
		[(? symbol?)
		 ; =>
		 `(,cont ,term)]))

	(define (cps-convert-program term)
	  (cps-convert term '(lambda (ans) ans)))

For those interested, Olivier Danvy has plenty of papers on writing efficient CPS converters.
올리버 댄비는 효과적인 CPS 변환기에 관한 많은 논문을 써냈다.

# Implementing call/cc in Lisp
# Lisp에서 call/cc 구현하기

The primitive call-with-current-continuation (commonly called call/cc) is the most powerful control-flow construct in modern programming.
기본적인 현재 continuation 호출(일반적으로 call/cc라고 불린다.)은 현대 프로그래밍에서 가장 강력한 제어 흐름 구조이다. 

CPS makes implementing call/cc trivial; it's a syntactic desugaring:
CPS를 사용하면 call/cc를 아주 쉽게 구현할수 있다. 이는 문법적 디슈거링이다. 

	call/cc => (lambda (f cc) (f (lambda (x k) (cc x)) cc))

This desugaring (in conjunction with the CPS transformation) is the best way to understand exactly what call/cc does.
이 디슈거링은 call/cc가 정확히 무엇인지 이해할 수 있는 최고의 방법이다.

It does exactly what it's name says it will: it calls the procedure given as an argument with a procedure that has captured the current continuation.


When that procedure capturing the continuation gets invoked, it "returns" the computation to the point at which the computation was created.

# Implementing call/cc in JavaScript
# JavaScript에서 call/cc 구현하기

If one were to translate to continuation-passing style in JavaScript, call/cc has a simple definition:
만약 자바스크립트에서 무엇인가가 CPS로 바뀐다면 call/cc는 간단하게 정의할 수 있다.

	function callcc (f,cc) { 
	  f(function(x,k) { cc(x) },cc)
	}

# More resources
# 더 읽어 볼 것 

   * JavaScript: The Definitive Guide, the best book on JavaScript.
   * JavaScript: The Good Parts, the only other good JavaScript book.
   * Andrew Appel's timeless classic Compiling with Continuations.
   * The Lambda Papers.
   * My post on programming with continuations by example.
   * Jay McCarthy et al.'s papers on a continuation-based web-server.
