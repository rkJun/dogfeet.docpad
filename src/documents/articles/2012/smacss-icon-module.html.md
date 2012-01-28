--- yaml
layout: 'article'
title: 'SMACSS:The Icon Module'
author: 'Changwoo Park'
date: '2012-1-8'
tags: ['CSS', 'SMACSS', 'Icon', 'CSS Sprite']
---

이글은 [The Icon Module][]을 정리한 것이다. [SMACSS][]를 읽고 SMACSS의 철학이 실제로 어떻게 적용되는지 알아보기에 좋다. 게다가 Icon을 개발하는 최고이 메뉴얼중 하나이기도 하다.

이 글은 무료로 공개돼 있지 않다. 원문을 번역한 것은 아니고 책을 구입했지만 이 글만 읽어도 이해할 수 있는 수준으로 정리했기 때문에 저작권에 저촉될지도 모르겠다. 그래서 부연 설명은 필요하지만 잘라버렸다. 그러니 원문을 구입해 다시 읽어보기 바란다.

## SMACSS

[SMACSS][]는 좋은 책이다. `관리`에 포커스를 맞추고 이렇게 일목요연하게 정리된 자료는 일찍이 보지 못했다. 이 글을 읽고 도움이 됐다면 [SMACSS][]를 꼭 구입하길 바란다. $30 짜리 workshop 계정을 위해 저자인 [누구누구][]는 유로 컨텐츠를 계속 업데이트 추가하겠다고 한다.

[The Icon Module]: https://smacss.com/book/icon-module
[SMACSS]: https://smacss.com/

## The Icon Module

Asset(Image)을 한 파일로 모으면 HTTP 요청 수도 줄고 이미 모든 Asset을 내려받았기 때문에 나중에 필요할 때 바로 사용할 수 있다. 이 것을 `CSS Sprite`라고 부른다.

다음 그림을 보면 이말이 무슨 뜻인지 알 수 있다:

![icon-menu](/articles/2012/smacss/icon-menu.png)

Menu HTML:

	<ul class="menu">
	    <li class="menu-inbox">Inbox</li>
	    <li class="menu-drafts">Drafts</li>
	</ul>

Menu CSS:

	.menu li {
	    background: url(/img/sprite.png) no-repeat 0 0;
	    padding-left: 20px;
	}

	.menu .menu-inbox {
	    background-position: 0 -20px;
	}

	.menu .menu-drafts {
	    background-position: 0 -40px;
	}

모든 Icon은 Sprite 파일 하나에 다 들어 있고 아이템마다 필요한 Icon이 있는 위치를 보여준다.

이걸로도 되긴 되지만 좀 더 작업을 다듬을 수 있다:

 * list 아이템이라는 특정 DOM에만 사용할 수 있다.
 * 모듈마다 Sprite를 항상 다시 만들어야 한다.
 * Positioning within the element was very fragile: bumping up font size could reveal other parts of the sprite.
 * Handling right-to-left interfaces was more difficult since we could only use horizontal sprites and fix the x position to 0.

이 이슈만 해결되면 소위 Icon Module이라 칭할 수 있다.

Icon Module을 사용하도록 HTML을 바꾼다:

	<li><i class="ico ico-16 ico-inbox"></i> Inbox</li>

`<i>` 태그는 간단하고 시맨틱과는 거리가 먼 태그다. Icon은 다른 텍스트를 부연 설명하는  거니까 별 내용 없는 태그라고 볼 수 있다. Icon이 혼자 쓰일때는 꼭 title 속성을 넣어줘서 Screen Reader나 tooltip에서 읽을 수 있도록 해주는 것이 좋다. `<i>` 태그가 싫다면 `<span>` 태그가 적당하다.

Icon에는 `<i>`만 사용할 거니까 HTML 의존성은 사라젔다. (이말이 좀 역설적인 것 같다. 내(@pismute) 생각에는 `<i>` 자체가 HTML 구조와 상관도 없고 별 의미도 없으니 Icon을 사용할 때 `<i>`를 사용하면 HTML 의존적이지 않다라고 말하는 것 같다.)

그리고 "ico ico-16 ico-inbox" 클래스는 각각 역활이 다르다. 게다가 `<img>` 태그와 잘 섞어 사용할 수 있다.

Icon Module CSS:

	.ico {
	    display: inline-block;
	    background: url(/img/sprite.png) no-repeat;
	    line-height: 0;
	    vertical-align: bottom;
	}

	.ico-16 {
	    height: 16px;
	    width: 16px;
	}

	.ico-inbox {
	    background-position: 20px 20px;
	}

	.ico-drafts {
	    background-position: 20px 40px;
	}

`ico` 클래스는 모듈의 기본적인 토대를 다지는 클래스다. `<img>`처럼 inline-block 엘리멘트로 만들고 `vertical-align`으로 Icon이 텍스트와 잘 어우러지도록 해준다. IE는 `inline-block`을 `block` 엘리먼트로 취급하기 때문에 IE에서는 `{ zoom:1; display:inline; }`로 해야 한다.

`ico-16`은 크기 정해주기 위함이다. ico 클래스에 같이 넣어줘도 되지만 Icon마다 크기가 다를 수도 있어서 이렇게 하는 거다.

`icon-inbox`는 Sprite 이미지에서의 Inbox용 Icon의 위치를 정의하는 것이다.

촘촘히 우겨 넣은 이미지:

![icon-menu2](/articles/2012/smacss/icon-menu2.png)

잘 우겨 넣으면 압축 효율이 좋아진다. 그리고 파일 사이즈도 더 작아지기 때문에 사이트 성능도 향상된다. 아직 [Smush.it][]이나 [ImageOptim][]을 사용해보지 않았으면 한번 사용해보는 것이 좋다.

[Smush.it]: http://www.smushit.com/ysmush.it/
[ImageOptim]: http://imageoptim.pornel.net/

Icon Module을 만들어 좀 더 유연하게 리팩토링해 보았다. 

