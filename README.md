# README

## 프로젝트 소개

Spotify 플레이리스트 데이터와 Apple Music API를 통해 Apple Music 플레이리스트 반환하기


### 1️⃣ 사용 언어

Ruby 3.2.2


### 2️⃣ 사용 프레임워크 및 라이브러리

- Ruby on Rails 7.1.1
- figaro
- httparty


### 3️⃣ API 설명

- `GET /tracks`
```
[
    {
        "id": ${track.id},
        "name": ${track.name},
        "artists": ${track.artists},
        "album": ${track.album},
        "is_playable": ${track.is_playable},
        "available_countries": ${track.available_countries},
        "isrc": ${track.isrc}
    },
    ...
]
```

- `GET /playlists`
```
data:
    [{
        "id": ${playlist.id},
        "title": ${playlist.title},
        "description": ${playlist.description},
        "track_ids": ${playlist.track_ids},
        "available_countries": ${playlist.available_countries}
        "created_at": ${playlist.created_at},
        "updated_at": ${playlist.updated_at},
    },
    ...]
```

- `POST /playlists`
```
parameter = {
    "json_data" : 생성할 플레이리스트의 Spotify JSON데이터,
    "title": 플레이리스트의 제목
}
```

- `GET /playlists/:id(playlists.id)/apple_music_playlist`
```
[
    apple_music_playlist: { Apple Music API로 불러온 tracks의 id들 },
    apple_music_track_information: {
        Apple Music API로 불러온 tracks의 데이터들
    },
    ...
]
```


### 4️⃣ RDB 및 데이터 스키마

#### tracks

| 필드명                | 타입      | 설명               |
|---------------------|----------|-------------------|
| id                  | integer  | 트랙 식별자        |
| name            | string   | 트랙 제목       |
| artists     | json   | 해당 트랙에 참여한 아티스트(가수)명 목록  |
| album     | string   | 해당 트랙이 실린 앨범명  |
| is_playable          | string   | 트랙 재생 가능 여부  |
| available_countries          | string   | 해당 트랙을 재생 가능한 국가  |
| isrc          | string   | 해당 트랙의 ISRC  |
| created_at          | datetime | 생성일시             |
| updated_at          | datetime | 업데이트 일시         |

각 열은 해당 필드의 속성을 설명합니다.

- `id`: 각 트랙의 고유 식별자입니다.
- `name`: 트랙의 제목입니다.
- `artists`: 트랙에 참여한 아티스트(가수)명 목록입니다. 여러 아티스트가 참여할 경우, 등록된 아티스트가 많아질 것이라는 점을 고려하여 각 아티스트의 고유 식별자로 대체하는 것을 고려해 JSON 배열 형태로 구성했습니다.
- `album`: 해당 트랙이 실린 앨범의 제목입니다.
- `is_playable`: 트랙 재생 가능 여부입니다. Default는 True이며, 특정 사유로 더이상 재생이 불가능하면 False로 처리하면 됩니다.
- `available_countries`: 해당 트랙을 재생 가능한 국가입니다. 두자리 국가코드가 담긴 JSON 배열로 구성되어있습니다.
- `isrc`: 해당 트랙의 국제 표준 음반 코드입니다.
- `created_at`: 트랙 데이터가 생성된 날짜와 시간입니다.
- `updated_at`: 트랙 데이터가 마지막으로 업데이트된 날짜와 시간입니다.

#### playlists

| 필드명          | 타입      | 설명              |
|---------------|----------|------------------|
| id            | integer  | 플레이리스트 식별자       |
| title       | string  | 플레이리스트 제목       |
| description           | string   | 유통사 등에 맞춰 구별 가능한 용도의 ID  |
| track_ids         | string   | 트랙 ID 목록         |
| available_countries         | json   | 재생 가능한 국가         |
| created_at    | datetime | 생성일시           |
| updated_at    | datetime | 업데이트 일시       |

각 열은 해당 필드의 속성을 설명합니다.

- `id`: 각 플레이리스트의 고유 식별자입니다.
- `title`: 플레이리스트의 제목입니다.
- `description`: 스트리밍할 유통사, 장르별 카테고리 등 용도에 맞춰 관리하기 위해 제작하였습니다.
- `track_ids`: 플레이리스트에 포함된 곡들의 track id를 배열에 담아 저장합니다. 실제 track 데이터 매핑 및 데이터 메모리 절약을 위해 string 형식으로 id만 담습니다.
- `available_countries`: 플레이리스트에 포함된 곡들의 공통된 재생 가능 국가를 JSON 배열로 저장합니다.
- `created_at`: 플레이리스트가 생성된 날짜와 시간입니다.
- `updated_at`: 플레이리스트가 마지막으로 업데이트된 날짜와 시간입니다.

## 실행 방법
1. Project clone
2. rbenv, ruby 설치
```
# Homebrew로 rbenv 및 ruby-build 설치
brew install rbenv
brew install ruby-build

# rbenv 환경 설정
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
source ~/.zshrc

# ruby 설치 및 설정
rbenv install 3.2.2
rbenv global 3.2.2
```
3. 라이브러리 설치
```
(cd project_folder) bundle install

# Apple Developer Developer Token 저장 위한 파일 생성. 퍼블릭 레포지토리이기 때문에 gitignore에 등록된 상태
gem install figaro

# application.yml
APPLE_MUSIC_DEVELOPER_TOKEN: 토큰 입력
```


## 고민한 사항

##### 1️⃣ 사용가능 국가 처리 방식

- Track마다 사용 가능 국가가 지정되어 있는 경우도 있고, 없는 경우도 있었습니다.
- 최대한 많은 국가에서 원활하게 활용할 수 있게 하기 위해 available_markets 지정되어있지 않은 경우를 제외하고, 공통으로 설정되어있는 국가를 모아 Playlist에 반영하도록 설정하였습니다.
- 많은 국가에서 해당 플레이리스트에 접근하게 하기 위해서는 Track 데이터들에 있는 available_markets에 등록된 모든 국가 코드를 담는 것도 고려하였으나, 플레이리스트의 원활한 재생이 가능한 선에서 많은 국가를 포함하는 것을 우선 목표로 설정하였습니다.

##### 2️⃣ Playlist를 불러올 때 Track 데이터 불러오는 방식

- **Track 데이터의 ID들을 배열 안에 담아 string으로 저장하는 이유**:
    - Track 데이터의 ID들을 배열로 담아 string 형태로 저장함으로써 데이터를 간단히 관리하고, 데이터 전송 시 처리하기 용이하게 했습니다. JSON 형식의 문자열로 저장함으로써 복잡한 데이터베이스 관계를 설정하지 않고도 여러 ID를 한 번에 저장할 수 있습니다.

- **`tracks` 메소드의 역할**:
    - `playlist.rb`의 `tracks` 메소드는 `track_ids`에 저장되어 있는 ID들을 JSON 형식으로 파싱하여 각 ID에 해당하는 Track 레코드를 조회합니다. 이를 통해 관련된 Track 데이터를 손쉽게 가져올 수 있도록 설정했습니다.

- **결과**:
    - 이 방법을 통해 Playlist와 Track 간의 데이터 처리를 빠르게 수행할 수 있었습니다. Track 데이터의 ID를 배열로 저장하고 이를 string으로 관리함으로써, 관련 데이터를 효율적으로 조회할 수 있었습니다. 또한, 복잡한 조인 연산 없이도 필요한 데이터를 가져올 수 있어 성능상 이점이 있었습니다.

- **아쉬움**:
    - 시간 여유가 더 있었다면 `track_ids` 대신 `tracks`라는 컬럼명을 사용하고, 데이터 타입을 JSON으로 구성해보는 실험을 했을 것입니다. JSON 타입을 사용하면 데이터 구조를 더 직관적으로 관리할 수 있으며, SQL 쿼리를 통한 데이터 조작도 더 유연해졌을 것입니다. 또한, JSON 형식으로 저장하면 각 Track의 추가적인 메타데이터를 함께 저장할 수 있는 유연성도 제공됩니다.

##### 3️⃣ 향후 확장성

1. **유저 정보 활용**
   - 유저 정보를 활용하여 각 플레이리스트를 누가 만들었는지 기록하고, 유저별로 좋아하는 트랙을 모아 플레이리스트를 제작 및 추가하는 기능을 만들 수 있습니다.
   - 더 나아가, 비슷한 장르 또는 같은 장르를 좋아하는 사람들이 좋아하는 음악을 추천해줄 수 있습니다.
   - 유저 프로필을 만들고, 해당 유저가 만든 플레이리스트를 공유하는 기능도 구현할 수 있을 것입니다.

2. **Spotify API와의 연동**
   - Spotify의 OAuth를 활용하여 로그인하고, Spotify에서 사용하는 플레이리스트를 그대로 가져와 Apple Music 플레이리스트로 변환하여 연동하는 아이디어를 구현하면 좋을 것 같습니다. 반대로, Apple Music에서 Spotify로의 반영도 가능합니다.
   - 이를 통해 두 플랫폼 간의 플레이리스트를 동기화하고, 사용자 경험을 향상시킬 수 있습니다.

3. **NoSQL의 활용**
   - Spotify와 Apple Music API의 정보를 불러와 활용할 가능성이 무궁무진하기 때문에, 대용량 데이터의 처리가 필요할 가능성이 높습니다.
   - Track의 아티스트 정보, Playlist의 여러 트랙 정보, 유저별로 좋아하는 트랙 또는 플레이리스트를 저장하기 위해 관계형 데이터베이스보다는 수평 확장이 용이한 NoSQL을 활용하는 것이 좋습니다.
   - NoSQL 데이터베이스를 사용하면 대규모 데이터를 효율적으로 처리하고, 빠른 검색과 높은 가용성을 제공할 수 있습니다.
