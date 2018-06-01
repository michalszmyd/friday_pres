# frozen_literal_string: true

class Activities
  def initialize(post_id:)
    @post_id        = post_id
    @sql_decoration = ''
  end

  def results
    @results ||= ActiveRecord::Base.connection
                                   .execute(sanitized_sql)
                                   .map(&method(:activity_build))
    assign_includes if @includes_for&.any?
    @results
  end

  def includes(*args)
    @includes_for = args
    self
  end

  def limit(number)
    @sql_decoration += " LIMIT #{number}"
    self
  end

  def offset(number)
    @sql_decoration += " OFFSET #{number}"
    self
  end

  def order(order_args)
    if order_args.is_a?(Symbol)
      @sql_decoration += " ORDER BY #{order_args} ASC"
    elsif order_args.is_a?(Hash)
      @sql_decoration += " ORDER BY #{order_args.keys.first} #{order_args.values.first.upcase}"
    end
    self
  end

  private

  def assign_includes
    @includes_for.each do |include_name|
      hash = {}
      includes = include_name.to_s
                             .humanize
                             .constantize
                             .where(id: @results.map(&:"#{include_name}_id").uniq)

      includes.each { |e| hash[e.id] = e }

      @results.each do |result|
        result.send(:"#{include_name}=", hash[result.send(:"#{include_name}_id")])
      end
    end
  end

  def activity_build(row)
    Activity.new(
      id:          row['id'],
      user_id:     row['user_id'],
      type:        row['type'],
      description: row['description'],
      created_at:  Time.zone.parse(row['created_at'])
    )
  end

  def sql
    %(
        SELECT id, user_id, 'comment' AS type, body AS description, created_at
        FROM comments WHERE comments.post_id = :post_id
      UNION
        SELECT id, user_id, 'like' AS type, '' AS description, created_at
        FROM likes WHERE likes.post_id = :post_id
      UNION
        SELECT id, user_id, 'reaction' AS type, name AS description, created_at
        FROM reactions WHERE reactions.post_id = :post_id
      #{@sql_decoration}
    )
  end

  def sanitized_sql
    ApplicationRecord.send(:sanitize_sql_array, [sql, post_id: @post_id])
  end
end
