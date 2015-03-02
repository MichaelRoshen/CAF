
counter_cache计数器缓存字段实现

初学者可能还没有听说过这个东西，那么下面得这个场景你一定会经常碰到
一个博客系统中，每个用户可能会发表多个文章，需求要求在用户个人主页显示
这个用户一共发了多少篇文章，很简单1对多关系，@user.topics.count
就行了，但是这个效率非常得低，rails提供了一种更便捷得方式叫做
counter_cache, 可以参考我之前发过得一篇博客，里面介绍得比较详细
http://michael-roshen.iteye.com/blog/2091590

counter_cache得远离很简单，就是在1对多关系中，在1得一段加上一个计数器
每当我有新得文章发布create得时候，＋1
每当删除一篇文章发布destroy得时候，－1
我们只需要在文章在创建和删除得时候，添加回调，来修改这个字段的值就可以了

今天我们来看一下Rubychina里面是如何处理的，因为rubychina使用了mongoid
而mongoid中又没有counter_cache这种用法，而是自己写了一个，我们来分析一下
这段代码：

模型关系：
首先要在User上加上topics_count，用来计数

class User
  include Mongoid::Document
  field :topics_count, type: Integer, default: 0
  has_many :topics, dependent: :destroy
end


class Topic
  include Mongoid::Document
  belongs_to :user, inverse_of: :topics
  counter_cache name: :user, inverse_of: :topics
end


module ClassMethods
  def counter_cache(metadata)
    counter_name = "#{metadata[:inverse_of]}_count"

    set_callback(:create, :after) do |document|
      relation = document.send(metadata[:name])
      if relation && relation.class.fields.keys.include?(counter_name)
        relation.inc(counter_name.to_sym => 1) 
      end
    end

    set_callback(:destroy, :after) do |document|
      relation = document.send(metadata[:name])
      if relation && relation.class.fields.keys.include?(counter_name)
        relation.inc(counter_name.to_sym => -1)
      end
    end
  end
end
