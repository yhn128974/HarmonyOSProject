import { Request } from 'basic/Index'
import { UserModel } from '../models'


export function handleLogin(account: UserModel) {
  return Request.post<string>('/driver/login/account', account)
}

