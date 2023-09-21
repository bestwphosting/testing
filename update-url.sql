UPDATE N1IoqiD_posts SET post_content = replace(post_content, 'template.bestwp.hosting', '%%HOST%%');
UPDATE N1IoqiD_posts SET guid = replace(guid, 'template.bestwp.hosting', '%%HOST%%');
UPDATE N1IoqiD_postmeta SET meta_value = replace(meta_value,'template.bestwp.hosting', '%%HOST%%');
UPDATE N1IoqiD_options SET option_value = replace(option_value, 'template.bestwp.hosting', '%%HOST%%') WHERE option_name = 'home' OR option_name = 'siteurl';
