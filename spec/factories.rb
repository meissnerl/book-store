FactoryBot.define do
    factory :author1 do
      first_name: "Logan"
      last_name: "Meissner"
    end

    factory :author2 do
        first_name: "Foo"
        last_name: "Bar"
    end

    factory :publisher1 do
        name: "pub1"
    end

    factory :publisher2 do
        name: "pub1"
    end

    factory :publisher3 do
        name: "test"
    end
end