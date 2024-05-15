export interface User {
  account: string
  password: string
}

export class UserModel implements User {
  account: string = ''
  password: string = ''

  constructor(model: User) {
    this.account = model.account
    this.password = model.password
  }
}
