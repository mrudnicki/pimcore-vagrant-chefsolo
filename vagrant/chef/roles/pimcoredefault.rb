name "pimcoredefault"
description "Clean Pimcore Environment"
run_list (
    [
        "recipe[pimcore::default]",
        "recipe[pimcore::mysql]",
        "recipe[pimcore::php-fpm]",
        "recipe[pimcore::nginx]",
        "recipe[pimcore::pimcore]"
    ]
)
default_attributes ({
        "dev_domain" => #{node["dev_domain"]},
        "php_memory_limit" => "512M",
        "dev_user" => "vagrant"
})