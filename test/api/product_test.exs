defmodule TiktokShopTest.Api.ProductTest do
  use TiktokShopTest.DataCase
  alias TiktokShop.Product

  setup do
    System.put_env("APP_KEY", "123123")
    System.put_env("APP_SECRET", "9751d6598735babe213e1f5bbe9864cd341b1231")
    Application.put_env(:tiktok_shop, :timeout, nil)
    :ok
  end

  describe "get product list" do
    test "without params" do
      assert {:error, %{page_size: ["is required"]}} = Product.get_product_list(%{})
    end

    test "without page_number" do
      assert {:error, %{page_number: ["is required"]}} =
               Product.get_product_list(%{page_size: 10})
    end

    test "page_number < 1" do
      assert {:error, %{page_number: ["must be greater than or equal to 1"]}} =
               Product.get_product_list(%{page_size: 10, page_number: 0})
    end

    test "page_size < 1" do
      assert {:error, %{page_size: ["must be greater than or equal to 1"]}} =
               Product.get_product_list(%{page_size: 0, page_number: 1})
    end

    test "page_size > 100" do
      assert {:error, %{page_size: ["must be less than or equal to 100"]}} =
               Product.get_product_list(%{page_size: 1000, page_number: 1})
    end

    test "search status not in list" do
      assert {:error, %{search_status: ["not be in the inclusion list"]}} =
               Product.get_product_list(%{page_size: 10, page_number: 1, search_status: 9})
    end

    test "update time negative" do
      assert {
               :error,
               %{
                 create_time_from: ["must be greater than or equal to 0"],
                 create_time_to: ["must be greater than or equal to 0"],
                 update_time_from: ["must be greater than or equal to 0"],
                 update_time_to: ["must be greater than or equal to 0"]
               }
             } =
               Product.get_product_list(%{
                 page_size: 10,
                 page_number: 1,
                 update_time_from: -1,
                 update_time_to: -1,
                 create_time_from: -1,
                 create_time_to: -1
               })
    end
  end

  describe "get product detail" do
    test "without param" do
      assert {:error, %{product_id: ["is required"]}} = Product.get_product_detail(%{})
    end

    test "type param invalid" do
      assert {:error, %{product_id: ["is not a string"]}} =
               Product.get_product_detail(%{product_id: 123})
    end
  end

  describe "deactivate products" do
    test "without param" do
      assert {:error, %{product_ids: ["is required"]}} = Product.deactivate_products(%{})
    end

    test "type param invalid, not array" do
      assert {:error, %{product_ids: ["is not an array"]}} =
               Product.deactivate_products(%{product_ids: 123})
    end

    test "type param invalid" do
      assert {:error, %{product_ids: ["is invalid"]}} =
               Product.deactivate_products(%{product_ids: [123]})
    end
  end

  describe "delete product" do
    test "without param" do
      assert {:error, %{product_ids: ["is required"]}} = Product.delete_products(%{})
    end

    test "type param invalid, not array" do
      assert {:error, %{product_ids: ["is not an array"]}} =
               Product.delete_products(%{product_ids: 123})
    end

    test "type param invalid" do
      assert {:error, %{product_ids: ["is invalid"]}} =
               Product.delete_products(%{product_ids: [123]})
    end
  end

  describe "get attributes" do
    test "without param" do
      assert {:error, %{category_id: ["is required"]}} = Product.get_attributes(%{})
    end

    test "type param invalid" do
      assert {:error, %{category_id: ["is not a string"]}} =
               Product.get_attributes(%{category_id: 123})
    end
  end

  describe "get category rules" do
    test "without param" do
      assert {:error, %{category_id: ["is required"]}} = Product.get_category_rules(%{})
    end

    test "type param invalid" do
      assert {:error, %{category_id: ["is not a string"]}} =
               Product.get_category_rules(%{category_id: 123})
    end
  end

  describe "upload image" do
    test "without param" do
      assert {:error, %{img_data: ["is required"]}} = Product.upload_images(%{})
    end

    test "miss param image_scene" do
      assert {:error, %{img_scene: ["is required"]}} =
               Product.upload_images(%{img_data: "aaaaaaa"})
    end

    test "miss param image_data" do
      assert {:error, %{img_data: ["is required"]}} = Product.upload_images(%{img_scene: 1})
    end

    test "type param image_data is not a string" do
      assert {:error, %{img_data: ["is not a string"]}} =
               Product.upload_images(%{img_data: 123, img_scene: 1})
    end

    test "type param image_scene not a integer" do
      assert {:error, %{img_scene: ["is not a integer"]}} =
               Product.upload_images(%{img_data: "image", img_scene: "scene value"})
    end

    test "type param image_scene < 1" do
      assert {:error, %{img_scene: ["must be greater than or equal to 1"]}} =
               Product.upload_images(%{img_data: "image", img_scene: 0})
    end

    test "type param image_scene > 5" do
      assert {:error, %{img_scene: ["must be less than or equal to 5"]}} =
               Product.upload_images(%{img_data: "image", img_scene: 6})
    end
  end

  describe "update file" do
    test "without param" do
      assert {:error, %{file_data: ["is required"], file_name: ["is required"]}} =
               Product.upload_files(%{})
    end

    test "miss param file_data" do
      assert {:error, %{file_data: ["is required"]}} = Product.upload_files(%{file_name: "aaaa"})
    end

    test "miss param file_name" do
      assert {:error, %{file_name: ["is required"]}} = Product.upload_files(%{file_data: "bbbb"})
    end

    test "type param file_data is not a string" do
      assert {:error, %{file_data: ["is not a string"]}} =
               Product.upload_files(%{file_data: 123, file_name: "aaaaa"})
    end

    test "type param file_name is not a string" do
      assert {:error, %{file_name: ["is not a string"]}} =
               Product.upload_files(%{file_data: "aaaaa", file_name: 123})
    end
  end

  describe "create product" do
    test "without param" do
      assert {
               :error,
               %{
                 skus: ["is required"],
                 category_id: ["is required"],
                 description: ["is required"],
                 images: ["is required"],
                 is_cod_open: ["is required"],
                 package_weight: ["is required"],
                 product_name: ["is required"]
               }
             } = Product.create_product(%{})
    end

    test "miss param product_name" do
      assert {:error, %{product_name: ["is required"]}} =
               Product.create_product(%{
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 # brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_name is not a string" do
      assert {:error, %{product_name: ["is not a string"]}} =
               Product.create_product(%{
                 product_name: 123,
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 # brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param description" do
      assert {:error, %{description: ["is required"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 category_id: "602097",
                 # brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param description is not a string" do
      assert {:error, %{description: ["is not a string"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description: 123,
                 category_id: "602097",
                 # brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param category_id" do
      assert {:error, %{category_id: ["is required"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param category_id is not a string" do
      assert {:error, %{category_id: ["is not a string"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: 123,
                 brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param brand_id is not a string" do
      assert {:error, %{brand_id: ["is not a string"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: 2_222_222,
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param images" do
      assert {:error, %{images: ["is required"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param images invalid, not a array" do
      assert {:error, %{images: ["is invalid"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: 123,
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param images is a empty array" do
      assert {:error, %{images: ["length must be greater than or equal to 1"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param images->id" do
      assert {:error, %{images: [%{id: ["is required"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param images->id is not a string" do
      assert {:error, %{images: [%{id: ["is not a string"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: 123}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param warranty_period is not a integer" do
      assert {:error, %{warranty_period: ["is not a integer"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: "",
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param warranty_period <1" do
      assert {:error, %{warranty_period: ["not be in the inclusion list"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 0,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param warranty_period >21" do
      assert {:error, %{warranty_period: ["not be in the inclusion list"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 22,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param warranty_policy is not a string" do
      assert {:error, %{warranty_policy: ["is not a string"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: 123,
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_length is not a integer" do
      assert {:error, %{package_length: ["is not a integer"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: "10",
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_length >60" do
      assert {:error, %{package_length: ["must be less than or equal to 60"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 61,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_length <1" do
      assert {:error, %{package_length: ["must be greater than or equal to 1"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 0,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_width is not a integer" do
      assert {:error, %{package_width: ["is not a integer"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: "10",
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_width >40" do
      assert {:error, %{package_width: ["must be less than or equal to 40"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 41,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_width <1" do
      assert {:error, %{package_width: ["must be greater than or equal to 1"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 0,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_height is not a integer" do
      assert {:error, %{package_height: ["is not a integer"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: "10",
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_height >35" do
      assert {:error, %{package_height: ["must be less than or equal to 35"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 36,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_height <1" do
      assert {:error, %{package_height: ["must be greater than or equal to 1"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 0,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param package_weight" do
      assert {:error, %{package_weight: ["is required"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_weight is not a string" do
      assert {:error, %{package_weight: ["is not a string"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: 10,
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param size_chart->img_id (if have param size_chart)" do
      assert {:error, %{size_chart: [%{img_id: ["is required"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10",
                 size_chart: %{},
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param size_chart->img_id is not a string" do
      assert {:error, %{size_chart: [%{img_id: ["is not a string"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10",
                 size_chart: %{img_id: 123},
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param product_certifications invalid, not a array" do
      assert {:error, %{product_certifications: ["is invalid"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10",
                 product_certifications: 123,
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->id (if have param product_certifications)" do
      assert {:error, %{product_certifications: ["is invalid"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10",
                 product_certifications: %{},
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->id is not a string" do
      assert {:error, %{product_certifications: [%{id: ["is required"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       },
                       %{
                         id: "asdfasdfasdfasdf",
                         name: "bbb.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{
                         id: "sdafasdfasdfasdfsd"
                       }
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param product_certifications->images invalid, not a array" do
      assert {:error, %{product_certifications: [%{images: ["is invalid"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       },
                       %{
                         id: "asdfasdfasdfasdf",
                         name: "bbb.pdf",
                         type: "PDF"
                       }
                     ],
                     images: 123
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->images->id (if have param product_certifications->images)" do
      assert {:error, %{product_certifications: [%{images: [%{id: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       },
                       %{
                         id: "asdfasdfasdfasdf",
                         name: "bbb.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->images->id is not a string" do
      assert {:error, %{product_certifications: [%{images: [%{id: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       },
                       %{
                         id: "asdfasdfasdfasdf",
                         name: "bbb.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: 123}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param product_certifications->files invalid, not a array" do
      assert {:error, %{product_certifications: [%{files: ["is invalid"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: 123,
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->files->id (if have param product_certifications->files)" do
      assert {:error, %{product_certifications: [%{files: [%{id: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         name: "bbb.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->filed->id is not a string" do
      assert {:error, %{product_certifications: [%{files: [%{id: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: 123,
                         name: "bbb.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->files->name (if have param product_certifications->files)" do
      assert {:error, %{product_certifications: [%{files: [%{name: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "1234567889",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->filed->name is not a string" do
      assert {:error, %{product_certifications: [%{files: [%{name: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "1234567889",
                         name: 123,
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->files->type (if have param product_certifications->files)" do
      assert {:error, %{product_certifications: [%{files: [%{type: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->filed->type is not a string" do
      assert {:error, %{product_certifications: [%{files: [%{type: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: 123
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param is_cod_open" do
      assert {:error, %{is_cod_open: ["is required"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param is_cod_open is not a boolean" do
      assert {:error, %{is_cod_open: ["is not a boolean"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: 123,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus" do
      assert {:error, %{skus: ["is required"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true
               })
    end

    test "param skus is not a array" do
      assert {:error, %{skus: ["is invalid"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: 123
               })
    end

    test "param skus is a empty array" do
      assert {:error, %{skus: ["length must be greater than or equal to 1"]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: []
               })
    end

    test "miss param skus->sales_attributes" do
      assert {:error, %{skus: [%{sales_attributes: ["is required"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes is not a array" do
      assert {:error, %{skus: [%{sales_attributes: ["is invalid"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: 123,
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes is a empty array" do
      assert {:error,
              %{skus: [%{sales_attributes: ["length must be greater than or equal to 1"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus->sales_attributes->attribute_id" do
      assert {:error, %{skus: [%{sales_attributes: [%{attribute_id: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->attribute_id is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{attribute_id: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: 100_000,
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->value_id is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{value_id: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         value_id: 123,
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->custom_value is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{custom_value: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: 123,
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus->sales_attributes->sku_img->id (if have param skus->sales_attributes->sku_img)" do
      assert {:error, %{skus: [%{sales_attributes: [%{sku_img: [%{id: ["is required"]}]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{}
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->sku_img->id is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{sku_img: [%{id: ["is not a string"]}]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: 123
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param sku->stock_infos is not a array" do
      assert {:error, %{skus: [%{stock_infos: ["is invalid"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: 123,
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param sku->stock_infos->warehouse_id (if have sku->stock_infos)" do
      assert {:error, %{skus: [%{stock_infos: [%{warehouse_id: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param sku->stock_infos->warehouse_id is not a string" do
      assert {:error, %{skus: [%{stock_infos: [%{warehouse_id: ["is not a string"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: 7_068_201_260_272_453_382,
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param sku->stock_infos->available_stock (if have sku->stock_infos)" do
      assert {:error, %{skus: [%{stock_infos: [%{available_stock: ["is required"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382"
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param sku->stock_infos->available_stock is not a integer" do
      assert {:error, %{skus: [%{stock_infos: [%{available_stock: ["is not a integer"]}]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: "200"
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param seller_sku is not a string" do
      assert {:error, %{skus: [%{seller_sku: ["is not a string"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: 123,
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param original_price" do
      assert {:error, %{skus: [%{original_price: ["is required"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3"
                   }
                 ]
               })
    end

    test "param original_price is not a string" do
      assert {:error, %{skus: [%{original_price: ["is not a string"]}]}} =
               Product.create_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: 100
                   }
                 ]
               })
    end
  end

  describe "update product" do
    test "without param" do
      assert {
               :error,
               %{
                 description: ["is required"],
                 is_cod_open: ["is required"],
                 package_weight: ["is required"],
                 product_name: ["is required"],
                 skus: ["is required"],
                 product_id: ["is required"]
               }
             } = Product.update_product(%{})
    end

    test "miss param product_id" do
      assert {:error, %{product_id: ["is required"]}} =
               Product.update_product(%{
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 # brand_id: "2222222",
                 images: [
                   %{
                     id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"
                   }
                 ],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_id is not a string" do
    end

    test "miss param product_name" do
      assert {:error, %{product_name: ["is required"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_name is not a string" do
      assert {:error, %{product_name: ["is not a string"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: 123,
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param description" do
      assert {:error, %{description: ["is required"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param description is not a string" do
      assert {:error, %{description: ["is not a string"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description: 123,
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param category_id is not a string" do
      assert {:error, %{category_id: ["is not a string"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: 602_097,
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param brand_id is not a string" do
      assert {:error, %{brand_id: ["is not a string"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: 2_222_222,
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param images invalid, not a array" do
      assert {:error, %{images: ["is invalid"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: 123,
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param images is a empty array" do
      assert {:error, %{images: ["length must be greater than or equal to 1"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param images->id" do
      assert {:error, %{images: [%{id: ["is required"]}]}} =
               Product.create_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param images->id is not a string" do
      assert {:error, %{images: [%{id: ["is not a string"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: 123}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param warranty_period is not a integer" do
      assert {:error, %{warranty_period: ["is not a integer"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: "1",
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param warranty_period <1" do
      assert {:error, %{warranty_period: ["not be in the inclusion list"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 0,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param warranty_period >21" do
      assert {:error, %{warranty_period: ["not be in the inclusion list"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 22,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param warranty_policy is not a string" do
      assert {:error, %{warranty_policy: ["is not a string"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: 123,
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_length is not a integer" do
      assert {:error, %{package_length: ["is not a integer"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: "10",
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 is_cod_open: true,
                 skus: [
                   %{
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_width is not a integer" do
      assert {:error, %{package_width: ["is not a integer"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: "10",
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_height is not a integer" do
      assert {:error, %{package_height: ["is not a integer"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: "10",
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param package_weight" do
      assert {:error, %{package_weight: ["is required"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param package_weight is not a string" do
      assert {:error, %{package_weight: ["is not a string"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: 10,
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param size_chart->img_id (if have param size_chart)" do
      assert {:error, %{size_chart: [%{img_id: ["is required"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 size_chart: %{},
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param size_chart->img_id is not a string" do
      assert {:error, %{size_chart: [%{img_id: ["is not a string"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 size_chart: %{img_id: 123},
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param product_certifications invalid, not a array" do
      assert {:error, %{product_certifications: ["is invalid"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: 123,
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->id (if have param product_certifications)" do
      assert {:error, %{product_certifications: [%{id: ["is required"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->id is not a string" do
      assert {:error, %{product_certifications: [%{id: ["is not a string"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: 123,
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param product_certifications->images invalid, not a array" do
      assert {:error, %{product_certifications: [%{images: ["is invalid"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: 123
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->images->id (if have param product_certifications->images)" do
      assert {:error, %{product_certifications: [%{images: [%{id: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->images->id is not a string" do
      assert {:error, %{product_certifications: [%{images: [%{id: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: 123}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param product_certifications->files invalid, not a array" do
      assert {:error, %{product_certifications: [%{files: ["is invalid"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: 123,
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->files->id (if have param product_certifications->files)" do
      assert {:error, %{product_certifications: [%{files: [%{id: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->filed->id is not a string" do
      assert {:error, %{product_certifications: [%{files: [%{id: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: 123,
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->files->name (if have param product_certifications->files)" do
      assert {:error, %{product_certifications: [%{files: [%{name: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->filed->name is not a string" do
      assert {:error, %{product_certifications: [%{files: [%{name: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: 123,
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param product_certifications->files->type (if have param product_certifications->files)" do
      assert {:error, %{product_certifications: [%{files: [%{type: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param product_certifications->filed->type is not a string" do
      assert {:error, %{product_certifications: [%{files: [%{type: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: 123
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param is_cod_open" do
      assert {:error, %{is_cod_open: ["is required"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "type param is_cod_open is not a boolean" do
      assert {:error, %{is_cod_open: ["is not a boolean"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: "true",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus" do
      assert {:error, %{skus: ["is required"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true
               })
    end

    test "param skus is not a array" do
      assert {:error, %{skus: ["is invalid"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: 123
               })
    end

    test "param skus is a empty array" do
      assert {:error, %{skus: ["length must be greater than or equal to 1"]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: []
               })
    end

    test "param skus->id is not a string" do
      assert {:error, %{skus: [%{id: ["is not a string"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: 123,
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus->sales_attributes" do
      assert {:error, %{skus: [%{sales_attributes: ["is required"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes is not a array" do
      assert {:error, %{skus: [%{sales_attributes: ["is invalid"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: 123,
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes is a empty array" do
      assert {:error,
              %{skus: [%{sales_attributes: ["length must be greater than or equal to 1"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus->sales_attributes->attribute_id" do
      assert {:error, %{skus: [%{sales_attributes: [%{attribute_id: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->attribute_id is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{attribute_id: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: 100_000,
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->value_id is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{value_id: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         value_id: 123,
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->custom_value is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{custom_value: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: 123,
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param skus->sales_attributes->sku_img->id (if have param skus->sales_attributes->sku_img)" do
      assert {:error, %{skus: [%{sales_attributes: [%{sku_img: [%{id: ["is required"]}]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{}
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param skus->sales_attributes->sku_img->id is not a string" do
      assert {:error, %{skus: [%{sales_attributes: [%{sku_img: [%{id: ["is not a string"]}]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: 123
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param sku->stock_infos is not a array" do
      assert {:error, %{skus: [%{stock_infos: ["is invalid"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: 123,
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param sku->stock_infos->warehouse_id (if have sku->stock_infos)" do
      assert {:error, %{skus: [%{stock_infos: [%{warehouse_id: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param sku->stock_infos->warehouse_id is not a string" do
      assert {:error, %{skus: [%{stock_infos: [%{warehouse_id: ["is not a string"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: 123,
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param sku->stock_infos->available_stock (if have sku->stock_infos)" do
      assert {:error, %{skus: [%{stock_infos: [%{available_stock: ["is required"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382"
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param sku->stock_infos->available_stock is not a integer" do
      assert {:error, %{skus: [%{stock_infos: [%{available_stock: ["is not a integer"]}]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: "200"
                       }
                     ],
                     seller_sku: "test3",
                     original_price: "100"
                   }
                 ]
               })
    end

    test "param seller_sku is not a string" do
      assert {:error, %{skus: [%{seller_sku: ["is not a string"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: 123,
                     original_price: "100"
                   }
                 ]
               })
    end

    test "miss param original_price" do
      assert {:error, %{skus: [%{original_price: ["is required"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3"
                   }
                 ]
               })
    end

    test "param original_price is not a string" do
      assert {:error, %{skus: [%{original_price: ["is not a string"]}]}} =
               Product.update_product(%{
                 product_id: "1729424254457776926",
                 product_name: "Onpoint product test",
                 description:
                   "<p>This is description test for action create a new product in the store Onpoint</p>",
                 category_id: "602097",
                 brand_id: "2222222",
                 images: [%{id: "tos-maliva-i-o3syd03w52-us/3f207be626e94581beb4749f154f8534"}],
                 warranty_period: 1,
                 warranty_policy: "Test policy for version trial 1 week",
                 package_length: 10,
                 package_width: 10,
                 package_height: 10,
                 package_weight: "10.000",
                 product_certifications: [
                   %{
                     id: "1111111",
                     files: [
                       %{
                         id: "dfgsdfgsdfgsdfg",
                         name: "aaaa.pdf",
                         type: "PDF"
                       }
                     ],
                     images: [
                       %{id: "sdafasdfasdfasdfsd"}
                     ]
                   }
                 ],
                 is_cod_open: true,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     sales_attributes: [
                       %{
                         attribute_id: "100000",
                         custom_value: "yellow",
                         sku_img: %{
                           id: "tos-maliva-i-o3syd03w52-us/08816f1b00bf4fd9980aa0cd441cbe5f"
                         }
                       },
                       %{
                         attribute_id: "100089",
                         custom_value: "small"
                       }
                     ],
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 200
                       }
                     ],
                     seller_sku: "test3",
                     original_price: 100
                   }
                 ]
               })
    end
  end

  describe "update price" do
    test "without param" do
      assert {:error, %{product_id: ["is required"], skus: ["is required"]}} =
               Product.update_price(%{})
    end

    test "miss param product_id" do
      assert {:error, %{product_id: ["is required"]}} =
               Product.update_price(%{
                 skus: [
                   %{
                     id: "1729424254457842462",
                     original_price: "69000"
                   }
                 ]
               })
    end

    test "miss param skus" do
      assert {:error, %{skus: ["is required"]}} =
               Product.update_price(%{product_id: "1729424254457776926"})
    end

    test "type param product_id is not a string" do
      assert {:error, %{product_id: ["is not a string"]}} =
               Product.update_price(%{
                 product_id: 123,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     original_price: "69000"
                   }
                 ]
               })
    end

    test "type param skus invalid, not a array" do
      assert {:error, %{skus: ["is invalid"]}} =
               Product.update_price(%{
                 product_id: "1729424254457776926",
                 skus: 123
               })
    end

    test "param skus is a empty array" do
      assert {:error, %{skus: ["length must be greater than or equal to 1"]}} =
               Product.update_price(%{
                 product_id: "1729424254457776926",
                 skus: []
               })
    end

    test "miss param skus->id" do
      assert {:error, %{skus: [%{id: ["is required"]}]}} =
               Product.update_price(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     original_price: "69000"
                   }
                 ]
               })
    end

    test "miss param skus->original_price" do
      assert {:error, %{skus: [%{original_price: ["is required"]}]}} =
               Product.update_price(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462"
                   }
                 ]
               })
    end

    test "type param skus->id is not a string" do
      assert {:error, %{skus: [%{id: ["is not a string"]}]}} =
               Product.update_price(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: 123,
                     original_price: "69000"
                   }
                 ]
               })
    end

    test "type param skus->original_price is not a string" do
      assert {:error, %{skus: [%{original_price: ["is not a string"]}]}} =
               Product.update_price(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     original_price: 69000
                   }
                 ]
               })
    end
  end

  describe "update stock" do
    test "without param" do
      assert {:error, %{product_id: ["is required"], skus: ["is required"]}} =
               Product.update_stock(%{})
    end

    test "miss param product_id" do
      assert {:error, %{product_id: ["is required"]}} =
               Product.update_stock(%{
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 269
                       }
                     ]
                   }
                 ]
               })
    end

    test "miss param skus" do
      assert {:error, %{skus: ["is required"]}} =
               Product.update_stock(%{product_id: "1729424254457776926"})
    end

    test "type param product_id is not a string" do
      assert {:error, %{product_id: ["is not a string"]}} =
               Product.update_stock(%{
                 product_id: 123,
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 269
                       }
                     ]
                   }
                 ]
               })
    end

    test "type param skus invalid, not a array" do
      assert {:error, %{skus: ["is invalid"]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: 123
               })
    end

    test "param skus is a empty array" do
      assert {:error, %{skus: ["length must be greater than or equal to 1"]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: []
               })
    end

    test "miss param skus->id" do
      assert {:error, %{skus: [%{id: ["is required"]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 269
                       }
                     ]
                   }
                 ]
               })
    end

    test "type param skus->id is not a string" do
      assert {:error, %{skus: [%{id: ["is not a string"]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: 123,
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 269
                       }
                     ]
                   }
                 ]
               })
    end

    test "miss param skus->stock_infos" do
      assert {:error, %{skus: [%{stock_infos: ["is required"]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462"
                   }
                 ]
               })
    end

    test "type param skus->stock_infos invalid, not a array" do
      assert {:error, %{skus: [%{stock_infos: ["is invalid"]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: 123
                   }
                 ]
               })
    end

    test "param skus->stock_infos is a empty array" do
      assert {:error, %{skus: [%{stock_infos: ["length must be greater than or equal to 1"]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: []
                   }
                 ]
               })
    end

    test "type param skus->stock_infos->warehouse_id is not a string" do
      assert {:error, %{skus: [%{stock_infos: [%{warehouse_id: ["is not a string"]}]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: 123,
                         available_stock: 269
                       }
                     ]
                   }
                 ]
               })
    end

    test "miss param skus->stock_infos->available_stock" do
      assert {:error, %{skus: [%{stock_infos: [%{available_stock: ["is required"]}]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382"
                       }
                     ]
                   }
                 ]
               })
    end

    test "type param skus->stock_infos->available_stock not a integer" do
      assert {:error, %{skus: [%{stock_infos: [%{available_stock: ["is not a integer"]}]}]}} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: "269"
                       }
                     ]
                   }
                 ]
               })
    end

    test "param skus->stock_infos->available_stock < 0" do
      assert {:error,
              %{
                skus: [
                  %{stock_infos: [%{available_stock: ["must be greater than or equal to 0"]}]}
                ]
              }} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: -1
                       }
                     ]
                   }
                 ]
               })
    end

    test "param skus->stock_infos->available_stock > 99999" do
      assert {:error,
              %{
                skus: [
                  %{stock_infos: [%{available_stock: ["must be less than or equal to 99999"]}]}
                ]
              }} =
               Product.update_stock(%{
                 product_id: "1729424254457776926",
                 skus: [
                   %{
                     id: "1729424254457842462",
                     stock_infos: [
                       %{
                         warehouse_id: "7068201260272453382",
                         available_stock: 100_000
                       }
                     ]
                   }
                 ]
               })
    end
  end

  describe "active product" do
    test "without param" do
      assert {:error, %{product_ids: ["is required"]}} = Product.active_product(%{})
    end

    test "type param invalid, not array" do
      assert {:error, %{product_ids: ["is not an array"]}} =
               Product.active_product(%{product_ids: 123})
    end

    test "type param invalid" do
      assert {:error, %{product_ids: ["is invalid"]}} =
               Product.active_product(%{product_ids: [123]})
    end
  end

  describe "recover product" do
    test "without param" do
      assert {:error, %{product_ids: ["is required"]}} = Product.recover_product(%{})
    end

    test "type param invalid, not array" do
      assert {:error, %{product_ids: ["is not an array"]}} =
               Product.recover_product(%{product_ids: 123})
    end

    test "type param invalid" do
      assert {:error, %{product_ids: ["is invalid"]}} =
               Product.recover_product(%{product_ids: [123]})
    end
  end
end
