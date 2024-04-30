export interface ChatResponse {
  message: string,
  data: data
}

export interface data {
  type: number
  info: info
}

export interface info {
  text: string
}

export class ChatResponseModel implements ChatResponse {
  message: string = ''
  data: data = new dataModel({} as data)

  constructor(model: ChatResponse) {
    this.message = model.message
    this.data = model.data
  }
}
export class dataModel implements data {
  type: number = 0
  info: info = new infoModel({} as info)

  constructor(model: data) {
    this.type = model.type
    this.info = model.info
  }
}
export class infoModel implements info {
  text: string = ''

  constructor(model: info) {
    this.text = model.text
  }
}
