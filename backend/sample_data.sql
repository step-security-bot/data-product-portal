do $$
declare
    -- BUSINESS AREAS
    hr_id uuid;
    sales_id uuid;
    marketing_id uuid;
    manufacturing_id uuid;

    -- DATA PRODUCT TYPES
    processing_type_id uuid;
    reporting_type_id uuid;
    exploration_type_id uuid;
    ingestion_type_id uuid;
    machine_learning_type_id uuid;
    analytics_type_id uuid;

    -- USERS
    alice_id uuid;
    bob_id uuid;
    jane_id uuid;
    john_id uuid;

    -- DATA PRODUCTS
    sales_funnel_optimization_id uuid;
    customer_segmentation_id uuid;
    marketing_campaign_id uuid;
    sales_forecast_id uuid;

    -- DATASETS
    customer_data_id uuid;
    sales_data_id uuid;
    products_data_id uuid;
    stores_data_id uuid;
    employees_data_id uuid;
begin
    TRUNCATE TABLE public.data_product_memberships CASCADE;
    TRUNCATE TABLE public.data_products_datasets CASCADE;
    TRUNCATE TABLE public.datasets_owners CASCADE;
    TRUNCATE TABLE public.datasets CASCADE;
    TRUNCATE TABLE public.data_products CASCADE;
    TRUNCATE TABLE public.users CASCADE;
    TRUNCATE TABLE public.data_product_types CASCADE;
    TRUNCATE TABLE public.business_areas CASCADE;
    TRUNCATE TABLE public.environments CASCADE;
    TRUNCATE TABLE public.tags CASCADE;

    -- PLATFORMS
    INSERT INTO public.platforms (id, "name") VALUES ('a9928457-8729-45d9-a341-3095a5ed768b', 'AWS');
    INSERT INTO public.platform_services (id, platform_id, "name") VALUES ('76c09bb8-1f71-4abf-a303-1f364cb3e1a2', 'a9928457-8729-45d9-a341-3095a5ed768b', 'S3');
    INSERT INTO public.platform_services (id, platform_id, "name") VALUES ('07c50c94-0a62-4a70-b2d6-f5978d0e9258', 'a9928457-8729-45d9-a341-3095a5ed768b', 'Glue');
    INSERT INTO public.platform_service_configs (id, platform_id, service_id, "config", created_on, updated_on, deleted_at) VALUES('6bd82fd6-9a23-4517-a07c-9110d83ab38f', 'a9928457-8729-45d9-a341-3095a5ed768b', '76c09bb8-1f71-4abf-a303-1f364cb3e1a2', '{"identifiers":["datalake","ingress","egress"]}', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);


    -- ENVIRONMENTS
    INSERT INTO public.environments ("name", context, is_default, created_on, updated_on, deleted_at) VALUES ('development', 'dev_context', true, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.environments ("name", context, is_default, created_on, updated_on, deleted_at) VALUES ('production', 'prd_context', false, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);

    -- BUSINESS AREAS
    INSERT INTO public.business_areas (id, "name", description, created_on, updated_on, deleted_at) VALUES ('672debaf-31f9-4233-820b-ad2165af044e', 'HR', 'Human Resources', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO hr_id;
    INSERT INTO public.business_areas (id, "name", description, created_on, updated_on, deleted_at) VALUES ('bd09093e-14ff-41c1-b74d-7c2ce9821d1c', 'Sales', 'Sales', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO sales_id;
    INSERT INTO public.business_areas (id, "name", description, created_on, updated_on, deleted_at) VALUES ('7d9ec9fd-89cf-477e-b077-4c8d1a3ce3cc', 'Marketing', 'Marketing', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO marketing_id;
    INSERT INTO public.business_areas (id, "name", description, created_on, updated_on, deleted_at) VALUES ('623e6fbf-3a06-434e-995c-b0336e71806e', 'Manufacturing', 'Manufacturing', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO manufacturing_id;

    -- DATA PRODUCT TYPES
    INSERT INTO public.data_product_types (id, "name", description, icon_key, created_on, updated_on, deleted_at) VALUES ('90ab1128-329f-47dd-9420-c9681bfc68c4', 'Processing', 'Processing', 'PROCESSING', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO processing_type_id;
    INSERT INTO public.data_product_types (id, "name", description, icon_key, created_on, updated_on, deleted_at) VALUES ('1b4a64b3-96fb-404c-a73c-294802dc9852', 'Reporting', 'Reporting', 'REPORTING', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO reporting_type_id;
    INSERT INTO public.data_product_types (id, "name", description, icon_key, created_on, updated_on, deleted_at) VALUES ('74b13338-aa85-4552-8ccb-7d51550c67de', 'Exploration', 'Exploration', 'EXPLORATION', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO exploration_type_id;
    INSERT INTO public.data_product_types (id, "name", description, icon_key, created_on, updated_on, deleted_at) VALUES ('c25cf2c2-418a-4d1d-a975-c6af61161546', 'Ingestion', 'Ingestion', 'INGESTION', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO ingestion_type_id;
    INSERT INTO public.data_product_types (id, "name", description, icon_key, created_on, updated_on, deleted_at) VALUES ('f1672c38-ad1a-401a-8dd3-e0b026ab1416', 'Machine Learning', 'Machine Learning', 'MACHINE_LEARNING', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO machine_learning_type_id;
    INSERT INTO public.data_product_types (id, "name", description, icon_key, created_on, updated_on, deleted_at) VALUES ('3c289333-2d55-4aed-8bd5-85015a1567fe', 'Analytics', 'Analytics', 'ANALYTICS', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO analytics_type_id;

    -- USERS
    INSERT INTO public.users (email, id, external_id, first_name, last_name, created_on, updated_on, deleted_at) VALUES ('alice.baker@gmail.com', 'a02d3714-97e3-40d8-92b7-3b018fd1229f', 'alice.baker@gmail.com', 'Alice', 'Baker', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO alice_id;
    INSERT INTO public.users (email, id, external_id, first_name, last_name, created_on, updated_on, deleted_at) VALUES ('bob.baker@gmail.com', '35f2dd11-3119-4eb3-8f19-01b323131221', 'bob.baker@gmail.com', 'Bob', 'Baker', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO bob_id;
    INSERT INTO public.users (email, id, external_id, first_name, last_name, created_on, updated_on, deleted_at) VALUES ('jane.doe@dataminded.com', 'd9f3aae2-391e-46c1-aec6-a7ae1114a7da', 'jane.doe@dataminded.com', 'Jane', 'Doe', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO jane_id;
    INSERT INTO public.users (email, id, external_id, first_name, last_name, created_on, updated_on, deleted_at) VALUES ('john.doe@dataminded.com', 'b72fca38-17ff-4259-a075-5aaa5973343c', 'john.doe@dataminded.com', 'John', 'Doe', timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO john_id;

    -- DATA PRODUCTS
    INSERT INTO public.data_products (id, "name", external_id, description, about, status, type_id, business_area_id, created_on, updated_on, deleted_at) VALUES ('e269fd59-14f4-4710-9ce0-bb31b1c8b541', 'Sales Funnel Optimization', 'sales_funnel_optimization', 'Analyze data to optimize the Sales Funnel', '<h2>Sales Funnel Optimization</h2><p></p><p>This data product aims to analyze the current sales funnel, identify drop-off points,  implement improvements, and test new strategies.</p><p></p><p><strong>Key objectives include:</strong></p><ul><li><p>Increase Conversion Rates</p></li><li><p>Enhance Lead Quality</p></li><li><p>Optimize Lead Nurturing Processes</p></li><li><p>Improve Sales Team Efficiency</p></li><li><p>Maximize Customer Lifetime Value (CLV)</p></li><li><p>Data-Driven Decision Making</p></li><li><p>Align Marketing and Sales Efforts</p></li><li><p>Enhance Customer Experience</p></li><li><p>Drive Revenue Growth</p></li></ul>', 'ACTIVE', exploration_type_id, sales_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO sales_funnel_optimization_id;
    INSERT INTO public.data_products (id, "name", external_id, description, about, status, type_id, business_area_id, created_on, updated_on, deleted_at) VALUES ('ffcf5286-8f14-4411-8dfe-75dc7ed9ec36', 'Consumer Analysis', 'consumer_analysis', 'Customer Segmentation and Targeting', '<h2>Consumer Analysis</h2><p></p><p>This data product aims to develop cutting-edge AI models for analyzing consumer behaviour. </p><p>By leveraging deep learning techniques, we strive to automate the analysis of consumer data, enabling more personalized targeting and customer retention.</p><p></p><p><strong>Primary benefits include:</strong></p><ul><li><p>Enhanced Personalization</p></li><li><p>Improved Customer Retention</p></li><li><p>Efficient Resource Allocation</p></li><li><p>Better Decision-Making</p></li></ul>', 'ACTIVE', analytics_type_id, marketing_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO customer_segmentation_id;
    INSERT INTO public.data_products (id, "name", external_id, description, about, status, type_id, business_area_id, created_on, updated_on, deleted_at) VALUES ('55394c2e-8d33-4397-a388-20338ff87c0a', 'Digital Marketing Data Ingestion', 'digital_marketing', 'Ingest data to support digital marketing', '<h2>Digital Marketing Data Ingestion</h2><p></p><p>This data product focuses on ingesting all data needed to support our Digital Marketing campaigns.</p><p></p><p><strong>Core goals are:</strong></p><ul><li><p>Data Source Identification and Integration</p></li><li><p>Data Cleaning and Transformation</p></li><li><p>Data Enrichment and Enhancement</p></li><li><p>Real-time and Batch Processing</p></li><li><p>Data Governance and Security</p></li><li><p>Automation and Scalability</p></li><li><p>Collaboration and Stakeholder Engagement</p></li></ul>', 'ACTIVE', ingestion_type_id, marketing_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO marketing_campaign_id;
    INSERT INTO public.data_products (id, "name", external_id, description, about, status, type_id, business_area_id, created_on, updated_on, deleted_at) VALUES ('4c3f686f-13ec-41c0-a31c-60a19f05bbe5', 'Sales Forecast', 'sales_forecast', 'Develop predictive models for sales forecasting', '<h2>Sales Forecast</h2><p></p><p>This data product focuses on developing predictive models for forecasting sales. By leveraging advanced analytics and machine learning, we aim to forecast sales results based on an extensive list of parameters.</p><p></p><p><strong>Strategic aims are:</strong></p><ul><li><p>Accurate Sales Predictions</p></li><li><p>Demand Planning and Inventory Management</p></li><li><p>Resource Allocation and Operational Efficiency</p></li><li><p>Strategic Decision Support</p></li><li><p>Risk Management and Scenario Planning</p></li><li><p>Performance Monitoring and KPI Tracking</p></li><li><p>Continuous Improvement and Innovation</p></li><li><p>Cross-functional Collaboration</p></li></ul>', 'PENDING', machine_learning_type_id, sales_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO sales_forecast_id;

    -- DATASETS
    INSERT INTO public.datasets (id, external_id, "name", description, about, status, access_type, business_area_id, created_on, updated_on, deleted_at) VALUES ('a1804479-c376-49cf-8970-29ec0ee0bc91', 'customer_data', 'Customer Data', 'Customer detail data from CRM, POS, loyalty programs, feedback systems, surveys, ...', '<h2>Customer Detail Data</h2><p></p><p>This dataset contains customer data obtained from various sources (CRM, POS, loyalty programs, feedback systems, surveys, …).</p><p></p><p><strong>Key components include:</strong></p><ul><li><p>Customer Demographics</p></li><li><p>Customer Segmentation Data</p></li><li><p>Purchase History</p></li><li><p>Behavioral Data</p></li><li><p>Customer Feedback</p></li><li><p>Loyalty Program Data</p></li><li><p>Customer Service Interactions</p></li></ul>', 'PENDING', 'RESTRICTED', marketing_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO customer_data_id;
    INSERT INTO public.datasets (id, external_id, "name", description, about, status, access_type, business_area_id, created_on, updated_on, deleted_at) VALUES ('590da97a-a689-4d1f-adf4-27d1f3fa28e8', 'sales_data', 'Sales', 'Sales detail data from POS, E- Commerce, OMS, accounting and billing, ...', '<h2>Sales Data</h2><p></p><p>This dataset contains sales data obtained from various sources (POS, E- Commerce, OMS, accounting and billing, …).</p><p></p><p><strong>Key components include:</strong></p><ul><li><p>Transaction Information</p></li><li><p>Product Details</p></li><li><p>Customer Information</p></li><li><p>Sales Representative Information</p></li><li><p>Location Details</p></li><li><p>Payment Information</p></li><li><p>Discounts and Promotions</p></li><li><p>Return and Refund Information</p></li></ul>', 'ACTIVE', 'PUBLIC', sales_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO sales_data_id;
    INSERT INTO public.datasets (id, external_id, "name", description, about, status, access_type, business_area_id, created_on, updated_on, deleted_at) VALUES ('e4621c2e-4855-44d0-924f-5f77d3860ae4', 'products_data', 'Products', 'Products detail data from PIM, ERP, ERP, Supply Chain Management, ...', '<h2>Products Data</h2><p></p><p>This dataset contains products data obtained from various sources (Product Information Management, ERP, Supply Chain Management, Third Party vendors, …).</p><p></p><p><strong>Key components include:</strong></p><ul><li><p>Product Identification</p></li><li><p>Product Attributes</p></li><li><p>Product Specifications</p></li><li><p>Product Images and Media</p></li><li><p>Pricing and Inventory</p></li><li><p>Sales and Marketing</p></li><li><p>Logistics and Fulfillment</p></li><li><p>Compliance and Regulatory Information</p></li><li><p>Customer Support</p></li></ul>', 'ACTIVE', 'PUBLIC', manufacturing_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO products_data_id;
    INSERT INTO public.datasets (id, external_id, "name", description, about, status, access_type, business_area_id, created_on, updated_on, deleted_at) VALUES ('cf6c98ae-44c2-4c63-90ff-0a8d6ec90f19', 'stores_data', 'Stores', 'Stores detail data from ERP, CRM, POS, ...', '<h2>Stores Data</h2><p></p><p>This dataset contains stores data obtained from various sources (ERP, CRM, POS, …).</p><p></p><p><strong>Key components include:</strong></p><ul><li><p>Store Identification</p></li><li><p>Location Information</p></li><li><p>Contact Details</p></li><li><p>Operating Hours</p></li><li><p>Store Facilities</p></li><li><p>Product Offering</p></li><li><p>Services Offered</p></li><li><p>Operational Details</p></li><li><p>Sales Performance</p></li></ul>', 'ACTIVE', 'PUBLIC', sales_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO stores_data_id;
    INSERT INTO public.datasets (id, external_id, "name", description, about, status, access_type, business_area_id, created_on, updated_on, deleted_at) VALUES ('4cd6e3d7-129f-496b-a9e5-c6fbdbc024e5', 'employees_data', 'Employee Data', 'Employee detail data from HRIS, Payroll,  Timesheets, ...', '<h2>Employee Data</h2><p></p><p>This dataset contains employee data obtained from various sources (HRIS, Payroll,  Timesheets, …).</p><p></p><p><strong>Key components include:</strong></p><ul><li><p>Personal Information</p></li><li><p>Employment Details</p></li><li><p>Compensation and Benefits</p></li><li><p>Time and Attendance</p></li><li><p>Performance Data</p></li><li><p>Training and Development</p></li><li><p>Engagement and Feedback</p></li><li><p>Compliance and Legal</p></li><li><p>IT and System Access</p></li></ul>', 'PENDING', 'RESTRICTED', hr_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL) returning id INTO employees_data_id;

    -- DATASET OWNERS
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (customer_data_id, john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (customer_data_id, jane_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (stores_data_id, john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (stores_data_id, bob_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (stores_data_id, jane_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (sales_data_id, bob_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (sales_data_id, jane_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (products_data_id, alice_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);
    INSERT INTO public.datasets_owners (dataset_id, users_id, created_on, updated_on) VALUES (employees_data_id, jane_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL);

    -- DATA PRODUCTS - DATASETS
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('0658e52e-b69e-4787-b7b1-df215d75329c', sales_funnel_optimization_id, sales_data_id, 'PENDING_APPROVAL', john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('8c9ae075-aac3-47f3-b46f-1e7d66ea008a', sales_funnel_optimization_id, stores_data_id, 'APPROVED', john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('9cc43cb5-f943-4f4e-8b41-8001fd33a0a0', sales_funnel_optimization_id, customer_data_id, 'APPROVED', bob_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('7df30caf-d2a7-4a39-b528-45a1aed7b4c0', sales_funnel_optimization_id, products_data_id, 'APPROVED', bob_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('f5923c52-d89e-429d-b2f2-ad8eb431a85e', customer_segmentation_id, sales_data_id, 'APPROVED', john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('c18ade7a-ef72-4da3-957d-60b750a21538', customer_segmentation_id, customer_data_id, 'PENDING_APPROVAL', alice_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('6d0c22f5-aa13-40c1-bef0-af996e9df9ce', marketing_campaign_id, sales_data_id, 'PENDING_APPROVAL', alice_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('e27d437d-ba3c-4633-a5c3-95474fbc61ca', marketing_campaign_id, customer_data_id, 'PENDING_APPROVAL', alice_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('24bf3a56-e48e-45de-a193-2164d0992b09', sales_forecast_id, sales_data_id, 'APPROVED', bob_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('0ab77909-c839-4048-8005-4f5604c6fa5e', sales_forecast_id, customer_data_id, 'APPROVED', john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_products_datasets (id, data_product_id, dataset_id, status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('96f62e70-e8d8-44b3-9303-e8e387a404b0', sales_forecast_id, products_data_id, 'APPROVED', john_id, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);

    -- DATA PRODUCT MEMBERSHIPS
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('b3f8e945-7aa8-449a-b1cc-036fb7b4bf0a', sales_funnel_optimization_id, john_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('74b2da72-fa7a-43c7-993e-34009be0356d', sales_funnel_optimization_id, bob_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('5e397d20-3eeb-4ac4-8f01-a4d16291b60f', sales_funnel_optimization_id, alice_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('2b60a98b-0d65-4064-90c0-a07f9a6e6ced', sales_funnel_optimization_id, jane_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('78155bc9-63e9-4cee-addf-64d71b10a3f5', customer_segmentation_id, john_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('9f0940c3-2830-45ea-879f-46512ca65194', customer_segmentation_id, bob_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('1655a4bd-737a-4cdb-9358-8061c5b9b82a', customer_segmentation_id, alice_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('768545c9-0455-41e8-8c5e-ec64e9256f83', customer_segmentation_id, jane_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('b359c0ce-2439-4e92-8b59-e9b4bcce3cc7', marketing_campaign_id, john_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('f7b2987a-91f3-4164-a8bb-ff636b93536b', marketing_campaign_id, bob_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('51adc7dd-c763-4a5a-9433-c606d139530b', marketing_campaign_id, alice_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('a6dd6ef9-7308-4bd7-b886-9ebd0a15f5bf', marketing_campaign_id, jane_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('1746925b-7733-4dc9-a788-1cd29e69c614', sales_forecast_id, john_id, 'OWNER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('c9e06816-e026-4495-aa0b-ed02419a4767', sales_forecast_id, bob_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);
    INSERT INTO public.data_product_memberships (id, data_product_id, user_id, "role", status, requested_by_id, requested_on, approved_by_id, approved_on, denied_by_id, denied_on, created_on, updated_on, deleted_at) VALUES ('00cb14d8-3b80-4a27-a743-cb8ae1548407', sales_forecast_id, alice_id, 'MEMBER','APPROVED', NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL, NULL, NULL, timezone('utc'::text, CURRENT_TIMESTAMP), NULL, NULL);

end $$;
