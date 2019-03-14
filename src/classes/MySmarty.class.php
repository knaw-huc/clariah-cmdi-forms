<?php if (!defined('BASE_URL')) exit('No direct script access allowed');

require(dirname(dirname(__FILE__)) . '/smarty/Smarty.class.php');

class Mysmarty extends Smarty
{
	function __construct()
	{
		parent::__construct();
		
		// absolute path prevents "template not found" errors
		$this->compile_dir = dirname(dirname(__FILE__)) . "/smarty/templates_c/";
		$this->template_dir = dirname(dirname(__FILE__)) . "/smarty/templates/"; 
		
		$this->assign("home_path", BASE_URL); 
		
	}
	
	function view($resource_name, $cache_id = null)   {
		if (strpos($resource_name, '.') === false) {
			$resource_name .= '.tpl';
		}
		return parent::display($resource_name, $cache_id);
	}
	
	function view2var($resource_name, $cache_id = null)   {
		if (strpos($resource_name, '.') === false) {
			$resource_name .= '.tpl';
		}
		return parent::fetch($resource_name, $cache_id);
	}
} // END class smarty_library
?>

