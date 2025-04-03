<h1 style='background-color: rgba(55, 55, 55, 0.4); text-align: center'>API 설계(명세)서 </h1>

해당 API 명세서는 'Flashcard 언어 학습 서비스 - Vocard'의 REST API를 명세하고 있습니다.

- Domain : http://localhost:4000

---

<h2 style='background-color: rgba(55, 55, 55, 0.2); text-align: center'>Auth 모듈</h2>

Vocard 서비스의 인증 및 인가와 관련된 REST API 모듈입니다.
로그인, 회원가입, 이메일 중복 확인, 이메일 인증 등의 API가 포함되어 있습니다.
Auth 모듈은 인증 없이 요청할 수 있는 모듈입니다.

- url : /api/v1/auth

---

#### - 로그인

##### 설명

클라이언트는 사용자 이메일과 평문의 비밀번호를 포함하여 요청하고 이메일과 비밀번호가 일치한다면 인증에 사용될 token과 해당 token의 만료 기간, 이메일 인증 여부를 응답 데이터로 전달받습니다. 만약 이메일 혹은 비밀번호가 하나라도 일치하지 않으면 로그인 불일치에 해당하는 응답을 받습니다. 만약 이메일 인증을 받지 않은 경우에는 이메일 인증 페이지로 리다이렉트 됩니다.서버 에러, 데이터베이스 에러, 유효성 검사 실패 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/sign-in**

##### Request

###### Request Body

| name     |  type  |   description   | required |
| -------- | :----: | :-------------: | :------: |
| email    | String |  사용자 이메일  |    O     |
| password | String | 사용자 비밀번호 |    O     |

###### Example

```bash
curl -v -X POST "http://localhost:4000/api/v1/auth/sign-in" \
 -d "email=qwer1234@gmail.com" \
 -d "password=qwer1234"
```

##### Response

###### Response Body

| name        |  type   |           description            | required |
| ----------- | :-----: | :------------------------------: | :------: |
| code        | String  |          응답 결과 코드          |    O     |
| message     | String  |    응답 결과 코드에 대한 설명    |    O     |
| accessToken | String  |  Bearer 인증 방식에 사용될 JWT   |    O     |
| expiration  | Integer | accessToken의 만료 기간 (초단위) |    O     |
| is_verified | Boolean |         이메일 인증상태          |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "accessToken": "${ACCESS_TOKEN}",
  "expiration": 32400,
  "is_verified": false
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (로그인 실패)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "SF",
  "message": "Sign In Fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 이메일 중복 확인

##### 설명

클라이언트는 사용할 이메일를 포함하여 요청하고 중복되지 않는 이메일이면 성공 응답을 받습니다. 만약 사용중인 이메일이라면 이메일 중복에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/email-check**

##### Request

###### Request Body

| name  |  type  |           description           | required |
| ----- | :----: | :-----------------------------: | :------: |
| email | String | 중복확인을 수행할 사용자 이메일 |    O     |

###### Example

```bash
curl -v -X POST "http://127.0.0.1:4000/api/v1/auth/email-check" \
 -d "email=qwer1234@gmail.com"
```

##### Response

###### Response Body

| name    |  type  |        description         | required |
| ------- | :----: | :------------------------: | :------: |
| code    | String |       응답 결과 코드       |    O     |
| message | String | 응답 결과 코드에 대한 설명 |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (중복된 이메일)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EE",
  "message": "Exist Email."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 회원가입

##### 설명

클라이언트는 이메일, 비밀번호, 닉네임을 포함하여 요청하고 회원가입이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 존재하는 이메일일 경우 중복된 이메일에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/sign-up**

##### Request

###### Request Body

| name     |  type  |                                      description                                       | required |
| -------- | :----: | :------------------------------------------------------------------------------------: | :------: |
| email    | String |                       사용자 이메일 (이메일 패턴을 가진 문자열)                        |    O     |
| password | String |            사용자 비밀번호 (영문 숫자 조합으로 이루어진 8자 이상의 문자열)             |    O     |
| nickname | String | 사용자 닉네임 (영문 또는 숫자 조합으로 이루어진 3자 이상의 문자열, 첫자는 무조건 영문) |    O     |

###### Example

```bash
curl -v -X POST "http://127.0.0.1:4000/api/v1/auth/sign-up" \
 -d "email=qwer1234@gmail.com" \
 -d "password=qwer1234" \
 -d "nickname=asd" \
```

##### Response

###### Response Body

| name    |  type  |        description         | required |
| ------- | :----: | :------------------------: | :------: |
| code    | String |       응답 결과 코드       |    O     |
| message | String | 응답 결과 코드에 대한 설명 |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (중복된 이메일)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EE",
  "message": "Exist Email."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 이메일 인증 코드 전송

##### 설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 요청하고 인증이 성공하면 해당 사용자의 이메일에 6자리의 숫자로된 코드를 발송합니다. 이 API는 이메일 인증이 아직 완료되지 않은 사용자만 호출할 수 있습니다, 서버 에러, 데이터베이스 에러, 유효성 검사 실패 에러, 이메일 전송 실패 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/send-email**

##### Requset

###### Header

| name          |      description      | required |
| ------------- | :-------------------: | :------: |
| Authorization | Bearer 토큰 인증 헤더 |    O     |

###### Request Body

###### Example

##### Response

###### Response Body

| name    |  type  |        description         | required |
| ------- | :----: | :------------------------: | :------: |
| code    | String |       응답 결과 코드       |    O     |
| message | String | 응답 결과 코드에 대한 설명 |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (인증된 이메일)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "AEV",
  "message": "Already Email Verified."
}
```

**응답 : 실패 (존재하지 않는 유저)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "UE",
  "message": "User Not Exist."
}
```

**응답 : 실패 (이메일 전송 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "EME",
  "message": "Email Error."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 이메일 인증 코드 확인

##### 설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 이메일 인증 코드를 입력하여 요청하고 인증이 성공하면 해당 사용자의 이메일 인증 상태(is_verified)가 true로 업데이트됩니다. 이메일 인증은 메인 페이지 등 주요 서비스 이용 전에 필수 절차로 인증이 완료되어야 메인 페이지 접근이 허용됩니다. 서버 에러, 데이터베이스 에러, 유효성 검사 실패 에러가 발생할 수 있습니다.

- method : **POST**
- URL : **/verify-email**

##### Request

##### Header

| name          |      description      | required |
| ------------- | :-------------------: | :------: |
| Authorization | Bearer 토큰 인증 헤더 |    O     |

###### Request Body

| name |  type  |   description    | required |
| ---- | :----: | :--------------: | :------: |
| code | String | 이메일 인증 코드 |    O     |

###### Example

```bash
curl -v -X POST "http://127.0.0.1:4000/api/v1/auth/verify-email" \
 -d "code=123456"
```

##### Response

###### Response Body

| name        |  type   |        description         | required |
| ----------- | :-----: | :------------------------: | :------: |
| code        | String  |       응답 결과 코드       |    O     |
| message     | String  | 응답 결과 코드에 대한 설명 |    O     |
| is_verified | boolean |      이메일 인증 여부      |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
  "is_verified": true
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (이메일 인증 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "EVF",
  "message": "Email Verification Fail."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 비밀번호 찾기

##### 설명

클라이언트는 이메일을 요청받아 데이터베이스에 존재하는 이메일일 경우 성공에 해당하는 응답을 받습니다. 성공 응답을 받으면 요청 받은 이메일의 비밀번호를 영 대소문자, 숫자, 특수문자(!?)가 포함된 랜덤한 문자열로 재설정 하여 해당 이메일로 평문으로된 비밀번호를 전송합니다. 이후 암호화 하여 DB에 저장합니다. 서버 에러, 데이터베이스 에러, 유효성 검사 실패 에러, 임시 비밀번호 발급 오류 에러가 발생할 수 있습니다.

- method : **PATCH**
- URL : **/reset-password**

##### Request

###### Request Body

| name  |  type  |  description  | required |
| ----- | :----: | :-----------: | :------: |
| email | String | 사용자 이메일 |    O     |

###### Example

```bash
curl -v -X PATCH "http://127.0.0.1:4000/api/v1/auth/reset-password" \
 -d "email=qwer1234@gmail.com"
```

##### Response

###### Response Body

| name    |  type  |        description         | required |
| ------- | :----: | :------------------------: | :------: |
| code    | String |       응답 결과 코드       |    O     |
| message | String | 응답 결과 코드에 대한 설명 |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 유저)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "UE",
  "message": "User Not Exist."
}
```

**응답 : 실패 (이메일 전송 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "EME",
  "message": "Email Error."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

<h2 style='background-color: rgba(55, 55, 55, 0.2); text-align: center'>Terms 모듈</h2>

Vocard 서비스의 단어장과 관련된 REST API 모듈입니다.  
단어 불러오기 API가 포함되어 있습니다.  
Terms 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.

- url : /api/v1/terms

---

#### - 영어 단어 불러오기

##### 설명

영어 단어를 불러오는 API입니다. 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러, 존재하지 않는 단어 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{language}/{book}/{level}/{day}**

##### Request

###### Path Variable

| name     |  type  |   description    | required |
| -------- | :----: | :--------------: | :------: |
| language | String |     언어코드     |    O     |
| book     | String |   단어장 이름    |    O     |
| level    | String | 단어장 레벨 정보 |    O     |
| day      | String |     Day 정보     |    O     |

###### Request Body

###### Example

```bash
curl -v -X PATCH "http://127.0.0.1:4000/api/v1/terms?language=en&book=toeic&level=800&day=1"
```

##### Response

###### Response Body

| name    |  type   |        description         | required |
| ------- | :-----: | :------------------------: | :------: |
| code    | String  |       응답 결과 코드       |    O     |
| message | String  | 응답 결과 코드에 대한 설명 |    O     |
| terms   | terms[] |      단어 리스트 배열      |    O     |

###### Terms

###### Example

| name            |  type  | description | required |
| --------------- | :----: | :---------: | :------: |
| term_id         |  Int   |   단어 Id   |    O     |
| word_code       | String |  단어 Code  |    O     |
| word            | String |    단어     |    O     |
| meaning         | String |   단어 뜻   |    O     |
| day_id          | String |  속한 day   |    O     |
| part_of_speech  | String |    품사     |    O     |
| phonetic        | String |  발음기호   |    O     |
| example         | String |    예문     |    O     |
| example_meaning | String |   예문 뜻   |    O     |
| synonym         | String |   유의어    |    O     |
| antonym         | String |   반의어    |    O     |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 단어)**

```bash
HTTP/1.1 404 Not Found

{
  "code": "NTF",
  "message": "No Terms Found."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 일본어 단어 불러오기

##### 설명

일본어 단어를 불러오는 API입니다. 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러, 존재하지 않는 단어 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{language}/{book}/{level}/{day}**

##### Request

###### Path Variable

| name     |  type  |   description    | required |
| -------- | :----: | :--------------: | :------: |
| language | String |     언어코드     |    O     |
| book     | String |   단어장 이름    |    O     |
| level    | String | 단어장 레벨 정보 |    O     |
| day      | String |     Day 정보     |    O     |

###### Request Body

###### Example

```bash
curl -v -X PATCH "http://127.0.0.1:4000/api/v1/terms?language=en&book=toeic&level=800&day=1"
```

##### Response

###### Response Body

| name    |  type   |        description         | required |
| ------- | :-----: | :------------------------: | :------: |
| code    | String  |       응답 결과 코드       |    O     |
| message | String  | 응답 결과 코드에 대한 설명 |    O     |
| terms   | terms[] |      단어 리스트 배열      |    O     |

###### Terms

###### Example

| name            |  type  | description | required |
| --------------- | :----: | :---------: | :------: |
| term_id         |  Int   |   단어 Id   |    O     |
| word_code       | String |  단어 Code  |    O     |
| word            | String |    단어     |    O     |
| meaning         | String |   단어 뜻   |    O     |
| day_id          | String |  속한 day   |    O     |
| yomigana        | String |  요미가나   |    O     |
| example         | String |    예문     |    O     |
| example_meaning | String |   예문 뜻   |    O     |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 단어)**

```bash
HTTP/1.1 404 Not Found

{
  "code": "NTF",
  "message": "No Terms Found."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 일본어 한자 불러오기

##### 설명

일본어 한자를 불러오는 API입니다. 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러, 존재하지 않는 단어 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{language}/{book}/{level}/{day}**

##### Request

###### Path Variable

| name     |  type  |   description    | required |
| -------- | :----: | :--------------: | :------: |
| language | String |     언어코드     |    O     |
| book     | String |   단어장 이름    |    O     |
| level    | String | 단어장 레벨 정보 |    O     |
| day      | String |     Day 정보     |    O     |

###### Request Body

###### Example

```bash
curl -v -X PATCH "http://127.0.0.1:4000/api/v1/terms?language=en&book=toeic&level=800&day=1"
```

##### Response

###### Response Body

| name    |  type   |        description         | required |
| ------- | :-----: | :------------------------: | :------: |
| code    | String  |       응답 결과 코드       |    O     |
| message | String  | 응답 결과 코드에 대한 설명 |    O     |
| terms   | terms[] |      단어 리스트 배열      |    O     |

###### Terms

###### Example

| name        |  type  | description | required |
| ----------- | :----: | :---------: | :------: |
| term_id     |  Int   |   단어 Id   |    O     |
| word_code   | String |  단어 Code  |    O     |
| word        | String |    단어     |    O     |
| meaning     | String |   단어 뜻   |    O     |
| day_id      | String |  속한 day   |    O     |
| shape       | String |   모양자    |    O     |
| radical     | String |    부수     |    O     |
| strokes     | String |    획수     |    O     |
| on_reading  | String |    음독     |    O     |
| kun_reading | String |    훈독     |    O     |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 단어)**

```bash
HTTP/1.1 404 Not Found

{
  "code": "NTF",
  "message": "No Terms Found."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 중국어 단어 불러오기

##### 설명

영어 단어를 불러오는 API입니다. 조회가 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 서버 에러, 인증 실패, 데이터베이스 에러, 존재하지 않는 단어 에러가 발생할 수 있습니다.

- method : **GET**
- URL : **/{language}/{book}/{level}/{day}**

##### Request

###### Path Variable

| name     |  type  |   description    | required |
| -------- | :----: | :--------------: | :------: |
| language | String |     언어코드     |    O     |
| book     | String |   단어장 이름    |    O     |
| level    | String | 단어장 레벨 정보 |    O     |
| day      | String |     Day 정보     |    O     |

###### Request Body

###### Example

```bash
curl -v -X PATCH "http://127.0.0.1:4000/api/v1/terms?language=en&book=toeic&level=800&day=1"
```

##### Response

###### Response Body

| name    |  type   |        description         | required |
| ------- | :-----: | :------------------------: | :------: |
| code    | String  |       응답 결과 코드       |    O     |
| message | String  | 응답 결과 코드에 대한 설명 |    O     |
| terms   | terms[] |      단어 리스트 배열      |    O     |

###### Terms

###### Example

| name      |  type  | description | required |
| --------- | :----: | :---------: | :------: |
| term_id   |  Int   |   단어 Id   |    O     |
| word_code | String |  단어 Code  |    O     |
| word      | String |    단어     |    O     |
| meaning   | String |   단어 뜻   |    O     |
| day_id    | String |  속한 day   |    O     |
| phonetic  | String |  발음기호   |    O     |

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 단어)**

```bash
HTTP/1.1 404 Not Found

{
  "code": "NTF",
  "message": "No Terms Found."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---

#### - 회독 기록 저장

##### 설명

사용자가 하나의 Day 학습을 완료했을 때 호출되는 API입니다. 서버는 해당 유저의 Day 회독 수를 1 증가시키고, 마지막 학습 일시를 업데이트합니다.

- method : **POST**
- URL : **/status**

##### Request

###### Header

| name          |      description      | required |
| ------------- | :-------------------: | :------: |
| Authorization | Bearer 토큰 인증 헤더 |    O     |

###### Request Body

| name  |  type  | description | required |
| ----- | :----: | :---------: | :------: |
| book  | String | 단어장 이름 |    O     |
| level | String |  레벨 정보  |    X     |
| day   | String |  Day 번호   |    O     |

###### Example

```bash
curl -v -X PATCH "http://127.0.0.1:4000/api/v1/terms/status" \
 -h "Authorization=Bearer XXXX" \
 -d "book=Toefl" \
 -d "level=900" \
 -d "day=Day1"
```

##### Response

###### Response Body

| name         |  type  |        description         | required |
| ------------ | :----: | :------------------------: | :------: |
| code         | String |       응답 결과 코드       |    O     |
| message      | String | 응답 결과 코드에 대한 설명 |    O     |
| review_count |  int   |         회독 횟수          |    O     |

###### Example

**응답 성공**

```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "review_count": 3
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**

```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (존재하지 않는 사용자)**

```bash
HTTP/1.1 401 Unauthorized

{
  "code": "UE",
  "message": "User Not Exist."
}
```

**응답 : 실패 (데이터베이스 에러)**

```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

---
