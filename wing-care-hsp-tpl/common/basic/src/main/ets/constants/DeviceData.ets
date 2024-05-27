/**
 * 设备属性名称中英文映射
 */
import { ResManager } from '../utils/ResManager'

export interface DeviceFunctionItem {
  en: string
  cn: string
  icon: ResourceStr
}

export enum ProductNameMap {
  watch = 'watch',
  Access_control = 'Access_control',
  Blood_glucose_meter = 'Blood_glucose_meter'
}

export const ProductNameList: DeviceFunctionItem[] = [
  {
    en: ProductNameMap.watch,
    cn: '手表',
    icon: ResManager.IC_PROD_WATCH
  },
  {
    en: ProductNameMap.Access_control,
    cn: '门禁',
    icon: ResManager.IC_PROD_DOOR
  },
  {
    en: ProductNameMap.Blood_glucose_meter,
    cn: '血糖仪',
    icon: ResManager.IC_PROD_BLOOD
  }
]

export enum DeviceFunctionMap {
  HeartRate = 'HeartRate',
  BloodOxygen = 'BloodOxygen',
  BloodPressure = 'BloodPressure',
  BloodSugar = 'BloodSugar',
  Energy = 'Energy',
  Steps = 'Steps'
}

export const DeviceFunctionList: DeviceFunctionItem[] = [
  {
    en: DeviceFunctionMap.HeartRate,
    cn: '心率',
    icon: '/images/icon_hd_xl.png'
  },
  {
    en: DeviceFunctionMap.BloodOxygen,
    cn: '血氧',
    icon: '/images/icon_hd_xueyang.png'
  },
  {
    en: DeviceFunctionMap.BloodPressure,
    cn: '血压',
    icon: '/images/icon_hd_xueya.png'
  },
  {
    en: DeviceFunctionMap.BloodSugar,
    cn: '血糖',
    icon: '/images/icon_hd_xueyg.png'
  },
  {
    en: DeviceFunctionMap.Energy,
    cn: '能量',
    icon: '/images/icon_kaluli.png'
  },
  {
    en: DeviceFunctionMap.Steps,
    cn: '步数',
    icon: '/images/icon_hd_step.png'
  }
]

// 血糖测试
export interface BloodTimeItem {
  index: number
  label: string
  isSelected: boolean
}

export const BloodTimeList: BloodTimeItem[] = [
  { index: 0, label: '凌晨', isSelected: true },
  { index: 1, label: '早餐-前', isSelected: false },
  { index: 2, label: '早餐-后', isSelected: false },
  { index: 3, label: '午餐-前', isSelected: false },
  { index: 4, label: '午餐-后', isSelected: false },
  { index: 5, label: '晚餐-前', isSelected: false },
  { index: 6, label: '晚餐-后', isSelected: false },
  { index: 7, label: '睡前', isSelected: false }
]