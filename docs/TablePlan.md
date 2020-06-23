# コントローラー

## Tasksコントローラー
    indexアクション
    showアクション
    newアクション
    createアクション
    editアクション (本人のみ)
    updateアクション
    destroyアクション
## Usersコントローラー 
    showアクション
    editアクション
    signUpアクション
    signInアクション
    signOutアクション
    deleteアクション 　 (本人とAdminのみ)
## Adminコントローラー
    indexアクション 


# DB構成
 ## Taskテーブル
    title:string
    content:text
    status:integer (1:yet,2:doing,3:done)
    deadline:datetime
    important:boolean (緊急性が高いタスクはtrue)
    user_id:integer 

## Tagテーブル
    title:string

## Tag_Taskテーブル
   tag_id:integer 
   task_id:integer

## Userテーブル
   name:string
   email:string
   password_digest:string
   image:string
   introduction:text
   permission:boolean (凍結機能用)
   admin:boolean 
