    function [eye_region_img  mouth_region_img] = get_regions(face_image, model, posemap)

    bs = detect(face_image, model, model.thresh);
    bs = clipboxes(face_image, bs);
    bs = nms_face(bs,0.3);
    [eye_region_img  mouth_region_img] = showboxes(face_image, bs(1),posemap);
