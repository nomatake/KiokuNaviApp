import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // App
      'app.title': 'KiokuNavi',
      'app.subtitle': 'Let\'s learn together',
      
      // Common buttons
      'common.buttons.login': 'Login',
      'common.buttons.signup': 'Sign Up',
      'common.buttons.next': 'Next',
      'common.buttons.cancel': 'Cancel',
      'common.buttons.confirm': 'Confirm',
      'common.buttons.tryAgain': 'Try Again',
      'common.buttons.viewAnswer': 'View Answer',
      'common.buttons.receiveXP': 'Receive XP',
      'common.buttons.createAccount': 'Create Account',
      'common.buttons.google': 'Google',
      'common.buttons.allow': 'Allow',
      'common.buttons.dontAllow': 'Don\'t Allow',
      
      // Common status
      'common.status.correct': 'Correct',
      'common.status.incorrect': 'Incorrect',
      'common.status.selected': 'Selected',
      
      // Common navigation
      'common.navigation.home': 'Home',
      'common.navigation.training': 'Training',
      'common.navigation.ranking': 'Ranking',
      'common.navigation.course': 'Course',
      'common.navigation.others': 'Others',
      'common.navigation.tapToNavigate': 'Tap to navigate',
      
      // Auth
      'auth.root.studentLogin': 'Login as Student',
      'auth.root.parentLogin': 'Login as Parent',
      'auth.login.title': 'Login',
      'auth.login.studentTitle': 'Student Login',
      'auth.login.parentTitle': 'Parent Login',
      'auth.login.instruction': 'Please login',
      'auth.login.forgotPassword': 'Forgot Password?',
      'auth.login.form.email.label': 'Email',
      'auth.login.form.email.placeholder': 'Enter email address',
      'auth.login.form.emailOrUsername.label': 'Email or Username',
      'auth.login.form.emailOrUsername.placeholder': 'Enter email or username',
      'auth.login.form.password.label': 'Password',
      'auth.login.form.password.placeholder': 'Enter password',
      
      // Auth Register
      'auth.register.title': 'Create Parent Account',
      'auth.register.termsText': 'By signing up, you agree to KiokuNavi\'s Terms of Service and Privacy Policy',
      'auth.register.form.birthDate.label': 'Date of Birth',
      'auth.register.form.birthDate.placeholder': 'Example: 2000/01/01',
      'auth.register.form.parentEmail.label': 'Parent\'s Email Address',
      'auth.register.form.parentEmail.placeholder': 'Enter email address',
      'auth.register.form.password.label': 'Password',
      'auth.register.form.password.placeholder': 'Enter password',
      
      // Auth Forgot Password
      'auth.forgotPassword.title': 'Forgot Password?',
      'auth.forgotPassword.instruction': 'Enter your email address to receive a password reset link.',
      'auth.forgotPassword.form.email.label': 'Email Address',
      'auth.forgotPassword.form.email.placeholder': 'Enter email address',
      
      // Tutorial
      'tutorial.one.message': 'Hello! I\'m Kio!',
      'tutorial.two.message': 'Before starting your first lesson,\nplease answer a few simple questions!',
      'tutorial.three.question': 'Please tell us your situation',
      'tutorial.three.options.parent': 'Parent',
      'tutorial.three.options.child': 'Child',
      'tutorial.three.options.teacher': 'Teacher',
      'tutorial.four.question': 'What grade is your child in?',
      'tutorial.four.options.grade3': '3rd Grade',
      'tutorial.four.options.grade4': '4th Grade',
      'tutorial.four.options.grade5': '5th Grade',
      'tutorial.four.options.grade6': '6th Grade',
      'tutorial.four.options.grade7': '7th Grade',
      'tutorial.four.options.grade8': '8th Grade',
      'tutorial.five.question': 'Which cram school do you attend?',
      'tutorial.five.options.waseda': 'Waseda Academy',
      'tutorial.five.options.yotsuya': 'Yotsuya Otsuka',
      'tutorial.five.options.sapix': 'SAPIX',
      'tutorial.five.options.nichinoken': 'Nichinoken',
      'tutorial.five.options.other': 'Other',
      'tutorial.six.question': 'Please enter your child\'s name',
      'tutorial.seven.question': 'What daily goal would you like?',
      'tutorial.seven.options.fiveMin': '5 min / day',
      'tutorial.seven.options.tenMin': '10 min / day',
      'tutorial.seven.options.fifteenMin': '15 min / day',
      'tutorial.seven.options.thirtyMin': '30 min / day',
      'tutorial.eight.message': 'Great! With this, you can learn ◯◯ in the first week!',
      'tutorial.nine.notification': 'I\'ll send notifications to make lessons a habit!',
      'tutorial.nine.permission': 'Allow KiokuNavi to send and\nreceive notifications?',
      'tutorial.nine.allow': 'Allow',
      'tutorial.nine.dontAllow': 'Don\'t Allow',
      'tutorial.nine.reminderText': 'Receive lesson reminders',
      
      // Learning
      'learning.question.header': 'Please select the correct meaning',
      'learning.question.text': 'Interested in archaeology',
      'learning.answers.option1': 'To be interested in something',
      'learning.answers.option2': 'To feel deeply in one\'s heart',
      'learning.answers.option3': 'A heart that pleases others',
      'learning.result.title': 'Challenge Complete!',
      'learning.result.totalXP': 'Total XP',
      'learning.result.time': 'Time',
      'learning.result.accuracyRate': 'Accuracy Rate',
      
      // Course
      'course.sections.start': 'Start',
      'course.sections.basicLearning': 'Basic Learning',
      'course.sections.appliedProblems': 'Applied Problems',
      'course.sections.practiceTest': 'Practice Test',
      
      // Subjects
      'subjects.comprehensive': 'Comprehensive',
      'subjects.socialStudies': 'Social Studies',
      'subjects.science': 'Science',
      'subjects.japanese': 'Japanese',
      
      // Validation
      'validation.required': 'Required',
      'validation.invalidEmail': 'Invalid email',
      'validation.passwordMinLength': 'Password must be at least 6 characters',
    },
    'ja_JP': {
      // App
      'app.title': 'キオクナビ',
      'app.subtitle': '楽しく学ぼう',
      
      // Common buttons
      'common.buttons.login': 'ログイン',
      'common.buttons.signup': '新規登録',
      'common.buttons.next': '次へ',
      'common.buttons.cancel': 'キャンセル',
      'common.buttons.confirm': '確認',
      'common.buttons.tryAgain': 'もう一度',
      'common.buttons.viewAnswer': '答えを見る',
      'common.buttons.receiveXP': 'XPを受け取る',
      'common.buttons.createAccount': 'アカウントを作成する',
      'common.buttons.google': 'Google',
      'common.buttons.allow': '許可する',
      'common.buttons.dontAllow': '許可しない',
      
      // Common status
      'common.status.correct': '正解',
      'common.status.incorrect': '不正解',
      'common.status.selected': '選択中',
      
      // Common navigation
      'common.navigation.home': 'ホーム',
      'common.navigation.training': 'トレーニング',
      'common.navigation.ranking': 'ランキング',
      'common.navigation.course': 'コース',
      'common.navigation.others': 'その他',
      'common.navigation.tapToNavigate': 'タップして移動',
      
      // Auth
      'auth.root.studentLogin': '生徒としてログイン',
      'auth.root.parentLogin': '保護者としてログイン',
      'auth.login.title': 'ログイン',
      'auth.login.studentTitle': '生徒ログイン',
      'auth.login.parentTitle': '保護者ログイン',
      'auth.login.instruction': 'ログインしてください',
      'auth.login.forgotPassword': 'パスワードを忘れた場合',
      'auth.login.form.email.label': 'メールアドレス',
      'auth.login.form.email.placeholder': 'メールアドレスを入力',
      'auth.login.form.emailOrUsername.label': 'メールアドレスまたはユーザー名',
      'auth.login.form.emailOrUsername.placeholder': 'メールアドレスまたはユーザー名を入力',
      'auth.login.form.password.label': 'パスワード',
      'auth.login.form.password.placeholder': 'パスワードを入力',
      
      // Auth Register
      'auth.register.title': '保護者アカウントの作成',
      'auth.register.termsText': '新規登録をすることにより、キオクナビのサービス利用規約とプライバシーポリシーに同意したものと見なされます',
      'auth.register.form.birthDate.label': '生年月日',
      'auth.register.form.birthDate.placeholder': '例: 2000/01/01',
      'auth.register.form.parentEmail.label': '保護者の方のメールアドレス',
      'auth.register.form.parentEmail.placeholder': 'メールアドレスを入力',
      'auth.register.form.password.label': 'パスワード',
      'auth.register.form.password.placeholder': 'パスワードを入力',
      
      // Auth Forgot Password
      'auth.forgotPassword.title': 'パスワードをお忘れですか？',
      'auth.forgotPassword.instruction': 'メールアドレスを入力して、パスワード再設定のリンクを受け取りましょう。',
      'auth.forgotPassword.form.email.label': 'メールアドレス',
      'auth.forgotPassword.form.email.placeholder': 'メールアドレスを入力',
      
      // Tutorial
      'tutorial.one.message': 'こんにちは！キオだよ！',
      'tutorial.two.message': '最初のレッスンを始める前に、\nn個の簡単な質問に答えてね！',
      'tutorial.three.question': 'あなたの状況を教えてください',
      'tutorial.three.options.parent': '保護者',
      'tutorial.three.options.child': '児童',
      'tutorial.three.options.teacher': '教師',
      'tutorial.four.question': 'お子様の学年を教えてください',
      'tutorial.four.options.grade3': '小学３年生',
      'tutorial.four.options.grade4': '小学４年生',
      'tutorial.four.options.grade5': '小学５年生',
      'tutorial.four.options.grade6': '小学６年生',
      'tutorial.four.options.grade7': '中学１年生',
      'tutorial.four.options.grade8': '中学２年生',
      'tutorial.five.question': '通っている塾はどれですか？',
      'tutorial.five.options.waseda': '早稲田アカデミー',
      'tutorial.five.options.yotsuya': '四谷大塚',
      'tutorial.five.options.sapix': 'SAPIX',
      'tutorial.five.options.nichinoken': '日能研',
      'tutorial.five.options.other': 'それ以外',
      'tutorial.six.question': 'お子様のお名前を入力してください',
      'tutorial.seven.question': '毎日の目標はどれがいい？',
      'tutorial.seven.options.fiveMin': '5分 / 日',
      'tutorial.seven.options.tenMin': '10分 / 日',
      'tutorial.seven.options.fifteenMin': '15分 / 日',
      'tutorial.seven.options.thirtyMin': '30分 / 日',
      'tutorial.eight.message': 'いいですね！これだと最初の１週間で◯◯学べるよ！',
      'tutorial.nine.notification': 'レッスンが習慣になるように通知を送るよ！',
      'tutorial.nine.permission': 'キオクナビ に通知の送信を\n許可して受信しますか？',
      'tutorial.nine.allow': '許可する',
      'tutorial.nine.dontAllow': '許可しない',
      'tutorial.nine.reminderText': 'レッスンリマインダーを受け取る',
      
      // Learning
      'learning.question.header': '正しい意味を選んでください',
      'learning.question.text': '考古学に関心がある',
      'learning.answers.option1': '物事に興味を抱くこと',
      'learning.answers.option2': '心に深く感ずること',
      'learning.answers.option3': '相手に気に入られる心',
      'learning.result.title': 'チャレンジ完了！',
      'learning.result.totalXP': '累計XP',
      'learning.result.time': '時間',
      'learning.result.accuracyRate': '正解率',
      
      // Course
      'course.sections.start': 'スタート',
      'course.sections.basicLearning': '基礎学習',
      'course.sections.appliedProblems': '応用問題',
      'course.sections.practiceTest': '実践テスト',
      
      // Subjects
      'subjects.comprehensive': '総合',
      'subjects.socialStudies': '社会',
      'subjects.science': '理科',
      'subjects.japanese': '国語',
      
      // Validation
      'validation.required': 'Required',
      'validation.invalidEmail': 'Invalid email',
      'validation.passwordMinLength': 'Password must be at least 6 characters',
    },
  };
}