<?php
class MY_Input extends CI_Input {
    private $json_body;
    public function is_post ()
    {
        return 'POST' == $this->method();
    }

    public function is_put ()
    {
        return 'PUT' == $this->method();
    }

    public function is_delete ()
    {
        return 'DELETE' == $this->method();
    }

    public function method ()
    {
        return $this->server('REQUEST_METHOD');
    }

    public function body ()
    {
        $method = $this->server('REQUEST_METHOD');
        if (in_array($method, array('POST', 'PUT')))
        {
            return file_get_contents('php://input');
        }
        return FALSE;
    }

    public function post ($name = NULL, $xss_clean = FALSE)
    {
        if ($name === NULL)
        {
            return parent::post();
        }

        if (isset($this->json_body))
        {
            if (isset($this->json_body->$name))
            {
                return $this->json_body->$name;
            }
            return FALSE;
        }

        $content_type = $this->server('CONTENT_TYPE');
        if ($content_type && substr($content_type, -5) == '/json')
        {
            $body = file_get_contents('php://input');
            $this->json_body = json_decode($body);
            return $this->post($name, $xss_clean);
        }

        return parent::post($name, $xss_clean);
    }

    public function json($name = NULL)
    {
        $body = file_get_contents('php://input');
        return $this->json_body = json_decode($body);
    }
}

