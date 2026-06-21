export class UserData {
  id: string = ''
  phone: string = ''
  nickname: string = ''
  avatar: string = ''
  token: string = ''
  isLogin: boolean = false
}

export class LoginParams {
  phone: string = ''
  code: string = ''
}

export class LoginResult {
  token: string = ''
  userInfo: UserData = new UserData()
}
