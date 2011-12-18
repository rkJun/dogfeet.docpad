--- yaml
layout: 'article'
title: 'CSS:SMACSS'
author: 'Changwoo Park'
date: '2011-12-25'
tags: ['CSS', 'SMACSS', 'Jonathan Snook', 'Review']
---

SMACSS('smacks'라고 읽는다)는 'Jonathan Snook'님의 오랜 경험과 통찰이 담겨있다. 이 것은 프레임워크라기 보다 스타일 가이드에 가깝기 때문에 만드는 사이트에 따라 그때그때 유연하게 사용할 수 있다.



_Back-End 출신이라 CSS를 사용할 때마다 '이 많은 스타일은 어떻게 관리해야 할까?' 라는 궁금중을 늘 가지고 있었습니다. 이 책은 그 궁금증을 해결해 줍니다. 디자인에 관련한 많은 얘기가 나옵니다. 읽긴 했지만 이해했다고 말하긴 어려워 보이는 수준입니다. Front-End에 조예가 깊으신 분이 읽으시면 다르게 정리할 것 같은 느낌이 드는 군요._

![SMACSS](/articles/2011/smacss/smacss.png)

## Review

[SMACSS][]는 저자인 Snooker님이 경험했던 Best Practice를 정리했다. Snooker님은 이 방법이 규모에 상관없이 효과적이라서 프로젝트 초반부터 성장하는 내내 유용하다고 설명한다.

Snooker님도 말하고 있지만 [SMACSS][]는 프레임워크가 아니라 스타일 가이드다. 그래서 어떤 라이브러리나 도구도 제공하지 않는다. [SMACSS][]는 CSS를 어떻게 구성하고 사용해야 하는가를 설명한다.

[SMACSS][]은 다음과 같은 주제를 다룬다:

 * Four Types of CSS Rules - 이게 SMACSS의 핵심이다. CSS를 네가지로 분류하고 어떻게 구분해 사용하는지 설명한다.
 * Themes and Typography - Theme와 Font에 대해 설명한다.
 * Depth of Applicability - Selector를 길게 만드는 것이 좋은지 짧게 만드는 것이 좋은지 설명한다. 즉, tradeoff에 대한 설명이다.
 * Selector Performance - 브라우저가 Selector를 어떻게 찾는지 설명한다.
 * State Representation
 * HTML5 and SMACSS
 * Prototyping
 * Formatting Code

이 중 `Four Types of CSS Rules`이 핵심인데 이 규칙은 다음과 같다:

 * Base Rule
 * Layout Rule
 * Module Rule
 * State Rule

[SMACSS Review][smacss-review]를 작성한 'Jonathan Christopher'님은 몇 시간이면 다 읽는다고 했는데 난 몇 일 걸렸다. 영어인데다가 분명 흥미로운 내용인데도 이상하게 읽어도읽어도 머리속에 잘 들어 오지 않았다. 'Chris'님 멍개 말미잘 뻥쟁이.

몇 년 전부터 이런 글을 읽고 싶었다. 이렇게 일목요연하게 가려운 부분을 긁어 주는 책을 찾은 내가 대견스럽다. CSS에 대한 책들은 모두 표현 방법에 대한 책들 뿐이다. 이렇게 CSS를 어떻게 관리해야 하는지를 설명하는 책은 정말 드물다.

[SMACSS][]는 유료 컨텐츠도 있지만 기본적으로 무료다. 만약 ebook 포멧으로 읽거나 숨겨진 컨텐츠를 읽고 싶으면 결제해야 하지만 책의 내용 대부분을 웹에서 무료로 읽을 수 있다. 하지만 구매하길 바란다. 무료로도 읽을 수 있지만 그만한 가치가 있다. 이 글을 쓰는 순간에 유료 컨텐츠는 'The Icon Module', 'Screencast: Applying the Principles'가 있다.

[smacss-review]: http://mondaybynoon.com/20120109/book-review-smacss/
[SMACSS]: http://smacss.com/

다음은 공부한 내용을 정리한 것이다. 읽고 해석한 대로 적은 것이니 원문과 다를 수도 있다. 번역을 하고 싶지만 시간도 저장권도 여의치 않을 것 같아서...
 
## Four Types of CSS Rules

SMACSS는 CSS Rule을 네가지로 나눈다. 

 * Base - 기본 스타일
 * Layout - 엘리먼트를 나열하는 것과 관련된 스타일
 * Module - 재사용 위해 하나로 묶는 스타일
 * State - Hidden/Expand나 Active/Inactive 같은 스타일

그 외 Theme와 Font Rule에 대해서 거론하지만 특별히 분류하지는 않았다. 대신 위 네 가지 Rule을 이용해서 Theme와 Font Rule을 만든다.

### Base

Base Rule을 쉽게 말하자면 id, class가 없는 스타일들을 말한다. 다음과 같은 것들이 Base Rule이다:

	html, body, form { margin: 0; padding: 0; }
	input[type=text] { boarder: 1px solid #999; }
	a { color: #039; }
	a:hover { color: #03C; }

Base Rule은 직접 이름지을 수 없는 element, attribute, psedo 셀렉터 등으로만 만든다.

#### CSS Reset

기본 margin, padding 등의 것을 규정하는 Base Rule을 CSS Reset이라고 부른다. 사실 Base Rule을 사용할 만한데가 CSS Reset밖에 없어 보인다. SMACSS는 element 셀렉터를 권장하지 않아서 element 셀렉터를 사용하도록 권장하는 부분은 Base Rule로 CSS Reset을 만들 때와 `.mod > input`처럼 child 셀렉터를 함께 쓸 때 뿐이다.

### Module

Module 스타일이 필요한 이유는 스타일을 Module 단위로 묶어서 재사용하기 위함이다. 사이드바나 제품 목록 등의 반복적으로 재사용하는 것들이 이에 해당된다. 

Module 스타일 이름은 3자로 제한해 사용한다. 하지만 스타일 가이드이니까 4자도 되고 글자제한이 없어도 된다:

	/* Example Module */
	.exm { }
	
	/* Callout Module */
	.cli { }
	
	/* Form field module */
	.fld { }

Exmaple Module에서 하위 스타일을 하나 만든다면 다음과 같이 하면된다:

	.exm-caption { }

Module은 재사용할 수 있어야 하기 때문에 id 셀렉터를 사용하지 않는다. 그리고 element 셀렉터도 사용하지 않는다. 다음과 같은 스타일과 html을 보자

	<div class="fld">
		<span>Folder Name</span>
	</div>

	.fld > span {
		padding-left: 20px;
		background: url(icon.png);
	}

이렇게 사용해도 무방하지만 프로젝트 규모가 커질 수록 다른 element로 바꿔야 할 수도 있고 element 본연의 특징을 유지하기 어려울 수 있다. `span`을 제거하고 다음과 같이 변경한다:

	<div class="fld">
		<span class="fld-name">Folder Name</span>
	</div>

	.fld > .fld-name {
		padding-left: 20px;
		background: url(icon.png);
	}

그래도 element 셀렉터를 꼭 사용해야 겠다면 `.fld > span`처럼 child 셀렉터를 꼭 함께 사용하라.

### Layout

Layout Rule이 엘리먼트를 어떻게 나열하는지 결정한다. 로그인 폼, 네비게이터 등 부터 header, footer같은 부분를 구분하는 것이 모두 Layout Rule이다.

`.l-fixed` 유무에 따라 가변폭으로 할지 고정폭으로 할지 결정하는 Layout은 다음과 같이 만든다:

	#article {
		width: 80%;
		float: left;
	}

	#sidebar {
		width: 20%;
		float: right;
	}

	.l-fixed #article {
		width: 600px;
	}

	.l-fixed #sidebar {
		width: 200px;
	}

id 셀렉터에는 'l'을 붙이지 않고 class 셀렉터에만 'l'을 붙인다. 전체 Layout처럼 큼직큼직한 Layout은 id 셀렉터로 스타일을 만들고 로그인 폼 같이 작은 부분의 스타일은 class 셀렉터로 만든다.

성능 등을 이유로 class 셀럭터없이 전부 id 셀렉터로 만들어도 되지만 꼭 그래야 할 이유는 없다. CSS에서는 id 셀렉터와 class 셀렉터 이 둘의 성능은 거의 같다. id 셀렉터가 Javascript에서 빠를지 모르겠지만 CSS는 아니다. 

그리고 Layout Rule만 id 셀렉터를 사용한다. 다른 스타일은 id 셀렉터 사용하지 않는다.

id 셀렉터에 tag 셀렉터와 함께 사용하지 않는다. 자식이면 child 셀렉터(>)를 꼭 사용한다.

### State

상태와 관련된 스타일을 말하고 이름을 지을때 's'를 붙인다. 예를 들면 이런거다:

	.s-hidden { display: none; }

이 State Rule은 `!important`를 사용해도 되는 스타일이다. 하지만 권장하지 않는다. 되도록 안쓰는 것이 좋다. 뭥미? 그냥 사용하지 말자.

## Themes and Typography

Theme와 Font를 위해 특별한 Rule을 만들지 않았다. 위에 설명한 네가지 Rule을 적절히 섞어서 잘 만들라는 얘기.

## Depth of Applicability

Depth는 쉽게 말해서 CSS 셀렉터의 길이를 의미한다. CSS Depth 문제는 이미 만들어진 HTML 구조에 의존적이라는 것이고 HTML 구조를 그대로 CSS 셀렉터에 표현하면 너무 길어진다. 예를 들어 다음과 같은 CSS Rule이 있으면:

	#sidebar div, #footer div {
		border: 1px solid #333;
	}

	#sidebar div h3, #footer div h3 {
		margin-top: 5px;
	}

	#sidebar div ul, #footer div ul {
		margin-bottom: 5px;
	}

이런걸 다음과 같이 바꿀 수 있다.

	.pod {
		border: 1px solid #333;
	}

	.pod > h3 {
		margin-top: 5px;
	}

	.pod > ul {
		margin-bottom: 5px;
	}

element마다 class 셀렉터를 만들지 않고 `.pod` 하나만 만들었다. 여전히 문서 구조는 남아 있지만 만든 class 셀렉터는 하나다. 이런 점이 "tradeoff"다. 한쪽으로 치우치면 다른 한쪽이 아쉽다.

이렇게 낮은(Shallow) Depth의 CSS은 템플릿 엔진을 사용할 때 효과적이다. 이 CSS를 따르는 [Mushache][]의 템플릿 코드를 살펴보자:

	<div class="pod">
		<h3>{{heading}}</h3>
		<ul>
			{{#items}}
			<li>{{item}}</li>
			{{/items}}
		</ul>
	</div>

요는 관리성, 성능, 가독성을 잘 조화시켜야 한다. CSS 셀렉터 길이가 너무 길면 "classitis"는 낮출 수 있지만 관리성과 가독성을 포기해야 한다. 반대로 모든 element에 class 셀렉터를 새로 만들어 줄 수도 있다. 이 예제에서 h3, h1에 까지 class 셀렉터를 부여하는 것은 조금 불필요하다.

Container는 보통 Header, Body, Footer 영역으로 나눈다. 이 것은 일종의 디자인 패턴이라고 할 수 있다. 그래서 `.pod > ul`을 다음과 같은 CSS Rule을 만들고 HTML에 적용시면:

	.pod-body {
		margin-bottom: 5px;
	}

ul대신 ol이나 div같은 element도 사용할 수 있다.

이렇게 단일 셀렉터를 사용하면 결국 '어떤 CSS 셀렉터를 사용해야 할지?' 더는 고민하지 않아도 된다. 특별한 이유가 없으면 이렇게 단일 셀렉터를 사용하는게 장땡이다.

[Mushache]: http://mustache.github.com/

## Selector Performance

[Google Page Speed][]같은 프로그램으로 한번 측정해보는 것이 좋겠지만...

그리고 evaluate는 뭘 말하는 걸까. element instance를 만들 때 CSS 스타일을 찾아 적용한다는 말 같은데... CSS 공부가 부족해 이런 것은 잘 모르겠다.

브라우저는 문서를 일종의 Stream으로 다룬다. 그러니까 먼저 들어온 element를 먼저 생성한다. 다음 예제를 보면:

	<body>
		<div id="content">
			<div class="module intro">
				<p>Lorem Ipsum</p>
			</div>
			<div class="module">
				<p>Lorem Ipsum</p>
				<p>Lorem Ipsum</p>
				<p>Lorem Ipsum <span>Test-</span></p>
			</div>
		</div>
	</body>

`body, div#content, div.module.intro ...` 순으로 evaluate한다는 말이다. 각 element를 evaluate할 때 Font는 뭐고, 컬러는 뭐고, 높이나 넓으는 얼마인지 브라우저는 자기가 정리한 스타일대로 사용한다. 그리고 element의 크기가 바뀌면 브라우저는 body부터 다시 그려야(Repaint)한다고 생각한다(저자는 다른 변수가 있는 사례가 있다고 의심하지만 확실한 것은 보통 width와 height값이 바뀌면 다시 그린다는 것이다).

### right to left

CSS는 오른쪽 부터 evaluate한다. `#content > div > p ` 같은 셀렉터가 있으면 p부터 찾는다. p, div, #conent 순으로 성능에 영향을 끼치니까 element 수를 잘 고려해야 한다. 

### 그외 다른 규칙은?

자세한 내용은 [Google Page Speed의 조언][]을 참고하는 것이 좋다. 여기서는 네가지만 짚고 넘어가자:

 * 

[Google Page Speed]: http://css-tricks.com/efficiently-rendering-css/
[Google Page Speed의 조언]: http://code.google.com/speed/page-speed/docs/rendering.html

http://css-tricks.com/efficiently-rendering-css/

## State Representation
## HTML5 and SMACSS
## Prototyping
## Formatting Code

### 연습

HTML5 structure에 적용한 sample 만들기


