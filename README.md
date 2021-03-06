# [function 개발새발()](https://dogfeet.github.com)


이 저장소는 블로그 [function 개발새발()](https://dogfeet.github.com)의 소스입니다.

이 블로그는 매 주 월요일 발행(빌드)하는 정통 주간 개발 블로그입니다.

이 블로그는 Docpad를 사용하고 있습니다. 글은 github-flavered-mardown으로 쓰고 layout은 CoffeeKup으로 합니다. 이 블로그에 참여하고 싶으신분은 Fork해서 글을 보내주세요.

## Author

글을 작성하면 꼭 src/documents/authors에 자신을 설명하는 글도 꼭 함께 작성해 주세요.

## Branch Naming Rule

브랜치는 다음과 같이 세 종류로 나눕니다. 

 * master - 이 브랜치의 것은 이미 배포했거나 즉시 배포할 것입니다. CI 서버가 이 브랜치에 있는 것을 빌드해서 배포합니다.
 * ready - 준비가 다 됐으면 이 브랜치에 Merge됩니다.
 * draft/xxx - 아직 공개하지 않지만 서로 리뷰하기 위해 사용하는 브랜치입니다. 다른 사람과 적극적으로 Push해서 공유합니다.
 * feature/xxx - page layout이나 Docpad plugin을 제작해서 서로 리뷰하기 위해 사용하는 브랜치 입니다.

master 브랜치는 항상 Fast-forward merge만 합니다. 즉, ready에 먼저 Merge해주세요.

