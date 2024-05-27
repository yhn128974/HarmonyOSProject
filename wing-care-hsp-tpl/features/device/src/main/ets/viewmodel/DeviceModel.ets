export class Device {
  name: string = ''
  icon: Resource | string=''
}

export class DeviceCate {
  title: string = ''
  list: Device[]=[]
  cb?: () => void = () => {
  }
}