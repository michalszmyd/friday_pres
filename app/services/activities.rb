# frozen_literal_string: true

class Activities
  # Activity = Struct.new(:id, :user_id, :type, :description, :created_at)

  def initialize(post_id:)
    @post_id   = post_id
    @sql_chain = ''
  end

  def results
    @results ||= ActiveRecord::Base.connection.execute(sanitized_sql).map { |row| activity_create(row) }
  end

  def user_includes
    @users = {}
    users  = User.where(id: results.map(&:user_id).uniq)
    users.each do |user|
      @users[user.id] = user
    end

    results.each do |result|
      result.user = @users[result.user_id]
    end
  end

  def limit(number)
    @sql_chain += " LIMIT #{number}"
    self
  end

  def offset(number)
    @sql_chain += " OFFSET #{number}"
    self
  end

  def order(data)
    @sql_chain +=
      if data.is_a?(Symbol)
        " ORDER BY #{data} ASC"
      elsif data.is_a?(Hash)
        " ORDER BY #{data.keys.join} #{data.values.join.upcase}"
      end
    self
  end

  private

  def activity_create(row)
    Activity.new(
      id:          row['id'],
      user_id:     row['user_id'],
      type:        row['type'],
      description: row['description'],
      created_at:  row['created_at']
    )
  end

  def sql
    %(
        SELECT
          id,
          user_id,
          'comment' AS type,
          body AS description,
          created_at
        FROM comments WHERE comments.post_id = :post_id
      UNION
        SELECT
          id,
          user_id,
          'like' AS type,
          '' AS description,
          created_at
        FROM likes WHERE likes.post_id = :post_id
      UNION
        SELECT
          id,
          user_id,
          'reaction' AS type,
          name AS description,
          created_at
        FROM reactions WHERE reactions.post_id = :post_id
      #{@sql_chain}
    )
  end

  def sanitized_sql
    ApplicationRecord.send(:sanitize_sql_array, [sql, post_id: @post_id])
  end
end
