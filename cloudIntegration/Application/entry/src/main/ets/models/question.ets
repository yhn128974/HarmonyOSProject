
// 试卷分类
export class  QuestionClassify {
  static className: string = "question_classify" // 表名
  id: number | null = null
  title: string = ""
  num: number  = 0
  image_url: string = ""
  remark: string = ""
  is_del: boolean = false
}
// 试卷
export class  QuestionPaper {
  static className: string = "question_paper"
  id: number | null = null
  classify_id: number = 0
  title: string = ""
  level: string  = ""
  order: number = 0
  remark: string = ""
}

// 试卷详情
export class  QuestionInfo {
  static className: string = "question_info"
  id: number | null = null
  classify_id: number = 0
  paper_id: number = 0
  title: string = ""
  order: number = 0
  question_type: string = ""
  answer_letter: string = ""
  right_answer_letter: string = ""
  answer_text: string = ""
  answer_solution: string = ""
}

// 试卷用户回答
export class  QuestionUserAll {
  static className: string = "question_user_all"

  id: number | null = null
  classify_id: number = 0
  paper_id: number = 0
  is_done: boolean = false
  score: number = 0
  start_time: Date = new Date()
  end_time: Date = new Date()
  user_id: string = ""
  remark: string = ""
}

// 用户回答的每个题目的详情
export class  QuestionUserAnswer {
  static className: string = "question_user_answer"

  id: number | null = null
  classify_id: number = 0
  question_info_id: number = 0
  paper_id: number = 0
  is_right: boolean = false
  answer_time: Date = new Date()
  user_id: string = ""
  user_answer: string = ""
}

// 用户信息
export class  UserInfo {
  static className: string = "user_info"
  id: number | null = null
  avatar: string = ""
  nick_name: string = ""
  user_id: string = ""
}
//
export enum QuestionTypeEnum {
  Judge = "1", // 判断
  Single = "2", // 单选
  Multi =  "3" // 多选
}

export class QuestionScoreDisplay extends QuestionUserAll {
  avatar: string = ""
  nick_name: string = ""
  constructor(obj: QuestionUserAll, avatar: string, nick_name: string) {
    super()
    this.avatar = avatar
    this.nick_name = nick_name
    this.id = obj.id
    this.classify_id = obj.classify_id
    this.paper_id = obj.paper_id
    this.user_id = obj.user_id
    this.is_done = obj.is_done
    this.start_time = obj.start_time
    this.end_time = obj.end_time
    this.remark = obj.remark
    this.score = obj.score
  }
}

export class UserCollect {
  all_people: number = 0
  all_wrong: number = 0
}


export interface AnswerItem {
  letter: string  // 选项的标识
  select: boolean  // 是否被选择
  letter_text: string  // 选项和标识的组合
}
@Observed
export class AnswerItemModel implements AnswerItem {
  letter: string = ''
  select: boolean = false
  letter_text: string = ''

  constructor(model: AnswerItem) {
    this.letter = model.letter
    this.select = model.select
    this.letter_text = model.letter_text
  }
}
