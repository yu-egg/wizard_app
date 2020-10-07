class Address < ApplicationRecord
  belongs_to :user, optional: true
  validates :postal_code, :address ,presence: true
end
# Userモデルに対して、optional: trueを設定します。
# これはbelongs_toの外部キーがnilであることを許可するオプションです。
# なぜこの設定が必要なのかは、後述します。

# また、「postal_codeカラム」と「addressカラム」に、空の場合はDBに保存しないというバリデーションを設定します。
# optional: trueを設定する理由
# 今回の場合、addressesテーブルのuser_idが外部キーになります。
# 住所情報を入力した時点で、user_idには値が入っていないので、通常ではバリデーションに引っかかり、DBに保存できません。そこで、optional: trueを設定することにより、外部キーがnilであってもDBに保存することができます。