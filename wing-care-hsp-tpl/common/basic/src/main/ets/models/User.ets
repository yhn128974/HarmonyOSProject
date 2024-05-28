export interface LoginParams {
  /**
   * 华为应用id
   */
  clientId: null | string;

  /**
   * 华为应用秘钥
   */
  clientSecret: null | string;

  /**
   * 华为账号授权码
   */
  code: string;

}

export interface UserData {
  /**
   * 头像
   */
  avatar: null | string;
  /**
   * 用户id
   */
  id: string;
  /**
   * 用户昵称
   */
  nickName: string;
  /**
   * 用户账号，即邮箱
   */
  username: string;
}
