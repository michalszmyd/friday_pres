# frozen_literal_string: true

class Activities
  def initialize(post_id:)
    @post_id = post_id
  end

  def results
    ActiveRecord::Base.connection.execute(sanitized_sql)
  end

  def sql
    %(
        SELECT id, user_id, 'comment' AS type, body AS description FROM comments WHERE comments.post_id = :post_id
      UNION
        SELECT id, user_id, 'like' AS type, '' AS description FROM likes WHERE likes.post_id = :post_id
      UNION
        SELECT id, user_id, 'reaction' AS type, name AS description FROM reactions WHERE reactions.post_id = :post_id
    )
  end

  def sanitized_sql
    ApplicationRecord.send(:sanitize_sql_array, [sql, post_id: @post_id])
  end
end
