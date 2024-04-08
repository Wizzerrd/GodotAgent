GDPC                 �                                                                         \   res://.godot/exported/133200997/export-2caee9b1d43ade828f6bf9980e8352fc-eidolon_handler.scn �      �      ��f 5'�WX31��Κ    P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn #      &      ���A@�%�)�!ƭ?(    P   res://.godot/exported/133200997/export-388bf9857f8605ce0d560309bd309226-ui.scn  `      �      ��h�S�l!6�    `   res://.godot/exported/133200997/export-e8a513ce05a6b8fc61fa03a4f371d15e-message_container.scn          �      ex�0=�R�e�J3��    ,   res://.godot/global_script_class_cache.cfg   )             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex0      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  �,      �       "��K(�3�4�P�        res://eidolon/EidolonHandler.gd         �      ):�(�.K�0�Y"M�    (   res://eidolon/eidolon_handler.tscn.remapP'      l       �I�GG$�W�T�%b^M       res://icon.svg   )      �      C��=U���^Qu��U3       res://icon.svg.import   !      �       Ǹ@���D�@��:�+�       res://main.gd   �!      G      "�Ƃ�3��к�p���       res://main.tscn.remap   �(      a       �J�Sw� ������       res://project.binary�-      K      �l�-	j�S���W       res://ui/UI.gd         W      �rp��ߘ��:��    (   res://ui/message_container.tscn.remap   �'      n       �{�/��w1�t��@4       res://ui/ui.tscn.remap  0(      _       �7��}�_�~L#M���    extends Node

var process_id = ""

var agent = "pirate_agent"
var title = "first meeting"

signal get_process_id(process_id: String)
signal get_message(message: String)


func _ready():
	var post_req = HTTPRequest.new()
	add_child(post_req)
	post_req.request_completed.connect(_set_process_id)
	var url = "http://localhost:8080/processes"
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var body = JSON.stringify({
		"agent": agent,
		"title": title
	})
	post_req.request(url, headers, method, body)

func post_message(message: String):
	var post_req = HTTPRequest.new()
	add_child(post_req)
	post_req.request_completed.connect(_render_response)
	var url = "http://localhost:8080/processes/%s/agent/%s/actions/converse" % [process_id, agent]
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var body = JSON.stringify(message)
	post_req.request(url, headers, method, body)
		
func _set_process_id(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	process_id = response.process_id
	get_process_id.emit(process_id)

func _render_response(result, response_code, headers, body):	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response is Dictionary:
		var message = response.data
		get_message.emit(message)
	
RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script     res://eidolon/EidolonHandler.gd ��������      local://PackedScene_td1i3          PackedScene          	         names "         EidolonHandler    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script           local://PackedScene_i534t �          PackedScene          	         names "         MessageContainer    anchor_right    anchor_bottom    offset_bottom    grow_horizontal    grow_vertical    HBoxContainer    	   variants            �?     �            node_count             nodes        ��������       ����                                             conn_count              conns               node_paths              editable_instances              version             RSRC               extends CanvasLayer

@export var message_container_scene: PackedScene

var waiting = false

signal send_message(message)

func add_message(sender, text):
	var container = message_container_scene.instantiate()
	var name = Label.new()
	var message = Label.new()
	name.text = sender + " -"
	message.autowrap_mode = 3
	message.text = text
	message.custom_minimum_size = Vector2(1000,0)
	container.add_child(name)
	container.add_child(VSeparator.new())
	container.add_child(message)
	$ScrollContainer/VBoxContainer.add_child(HSeparator.new())
	$ScrollContainer/VBoxContainer.add_child(container)
	
func validate_message(message):
	if not (
		ensure_message_contents(message)
	):
		return false
	return true
	
func ensure_message_contents(message):
	for i in range(len(message)):
		if (
			message[i] != ' ' 
			and message[i] != '\n' 
			and message[i] != '\t'
		):
			return true
	return false
	
func _on_button_pressed():
	if not waiting:
		var message = $MessageInput.text
		if validate_message(message):
			$MessageInput.clear()
			add_message("USER", message)
			waiting = true
			send_message.emit(message)
		
         RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://ui/UI.gd ��������   PackedScene     res://ui/message_container.tscn 6��'k      local://PackedScene_xcnu2 B         PackedScene          	         names "         UI    script    message_container_scene    CanvasLayer    MessageInput    offset_top    offset_right    offset_bottom 	   TextEdit    Button    offset_left    text    ScrollContainer    VBoxContainer    layout_mode    _on_button_pressed    pressed    	   variants    
                           D     �D     D     D     D    �D      SEND             node_count             nodes     =   ��������       ����                                  ����                                 	   	   ����   
                                                ����                                ����      	             conn_count             conns                                      node_paths              editable_instances              version             RSRC   GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://3ye7xm272utb"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 extends Node

func _on_eidolon_handler_get_process_id(process_id):
	var message = "Process ID: %s" % process_id
	$UI.add_message("SYSTEM", message)

func _on_ui_send_message(message):
	$EidolonHandler.post_message(message)

func _on_eidolon_handler_get_message(message):
	$UI.add_message("AGENT", message)
	$UI.waiting = false
         RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://main.gd ��������   PackedScene #   res://eidolon/eidolon_handler.tscn U4�*:#   PackedScene    res://ui/ui.tscn q�l.�m      local://PackedScene_eg0r3 q         PackedScene          	         names "         main    script    Node    EidolonHandler    UI     _on_eidolon_handler_get_message    get_message #   _on_eidolon_handler_get_process_id    get_process_id    _on_ui_send_message    send_message    	   variants                                         node_count             nodes        ��������       ����                      ���                      ���                    conn_count             conns                                                               
   	                    node_paths              editable_instances              version             RSRC          [remap]

path="res://.godot/exported/133200997/export-2caee9b1d43ade828f6bf9980e8352fc-eidolon_handler.scn"
    [remap]

path="res://.godot/exported/133200997/export-e8a513ce05a6b8fc61fa03a4f371d15e-message_container.scn"
  [remap]

path="res://.godot/exported/133200997/export-388bf9857f8605ce0d560309bd309226-ui.scn"
 [remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
               list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             U4�*:#"   res://eidolon/eidolon_handler.tscn6��'k   res://ui/message_container.tscnq�l.�m   res://ui/ui.tscn��ǡ1�   res://icon.svgk߰����   res://main.tscn  ECFG      application/config/name      	   AgentDemo      application/run/main_scene         res://main.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     input/enter�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility     