module Penrose

using GeometryTypes

export Dart, Kite
export placeDartEdge, placeKiteEdge
export translate, rotate, points, edge_points, edge_center, edge_angle, geometry

struct Dart
  cx::Number
  cy::Number
  angle::Number
  Dart(x,y,a) = new(x,y,(a+360)%360)
end

struct Kite
  cx::Number
  cy::Number
  angle::Number
  Kite(x,y,a) = new(x,y,(a+360)%360)
end

# Create a Dart whose edge is centered at the specified point and rotated by the specified angle
function placeDartEdge(edge, pt, edge_angle)

    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2

    if edge == 1
        newAngle = (edge_angle +360 - 252) % 360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = 1/4
        dy = h/2

        return Dart(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    elseif edge == 2
        newAngle = (edge_angle + 144) % 360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = 1/4 - phi/2
        dy = h/2

        return Dart(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    elseif edge == 3
        newAngle = (edge_angle + 360 + 36) % 360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = 1/4 - phi/2
        dy = -h/2

        return Dart(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    elseif edge == 4
        newAngle = (edge_angle + 360 + 252) % 360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = 1/4
        dy = -h/2

        return Dart(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    end
end

# Create a Kite whose edge is centered at the specified point and rotated by the specified angle
function placeKiteEdge(edge, pt, edge_angle)
    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2

    if edge == 1
        newAngle = (edge_angle + 216)%360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = phi/2 - 1/4
        dy = h/2

        return Kite(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    elseif edge == 2
        newAngle = (edge_angle + 360 - 252)%360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = -3/4
        dy = h/2
        return Kite(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    elseif edge == 3
        newAngle = (edge_angle + 72)%360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = -3/4
        dy = -h/2
        return Kite(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    elseif edge == 4
        newAngle = (edge_angle + 360 - 36)%360
        c = cos(newAngle * pi / 180)
        s = sin(newAngle * pi / 180)

        dx = phi/2 - 1/4
        dy = -h/2

        return Kite(pt[1] + dx*c - dy*s, pt[2] + dx*s + dy*c, newAngle)
    end
end

# Create a new object by rotating an existing one
function rotate(d::Dart, angle::Number)
    Dart(d.cx,d.cy,d.angle+angle)
end

function rotate(k::Kite, angle::Number)
    Kite(k.cx,k.cy,k.angle+angle)
end

# Create a new object by translating an existing one
function translate(d::Dart, dx::Number, dy::Number)
    @info "Create a copy of d translated by $dx, $dy"
    Dart(d.cx+dx,d.cy+dy,d.angle)
end

function translate(k::Kite, dx::Number, dy::Number)
    Kite(k.cx+dx,k.cy+dy,k.angle)
end

# Return the 4 points of an object in a form suitable for poly!
function geometry(d::Dart)
    c = cos(d.angle * pi / 180);
    s = sin(d.angle * pi / 180);
    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2

    Point2f0[[d.cx + c*( 0  ) - s*( 0), d.cy + s*( 0  ) + c*( 0)],
             [d.cx + c*(-1/2) - s*(-h), d.cy + s*(-1/2) + c*(-h)],
             [d.cx + c*( phi) - s*( 0), d.cy + s*( phi) + c*( 0)],
             [d.cx + c*(-1/2) - s*( h), d.cy + s*(-1/2) + c*( h)]]
end

function geometry(k::Kite)
    c = cos(k.angle * pi / 180);
    s = sin(k.angle * pi / 180);
    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2

    Point2f0[[k.cx + c*(-phi) - s*( 0), k.cy + s*(-phi) + c*( 0)],
             [k.cx + c*( 1/2) - s*(-h), k.cy + s*( 1/2) + c*(-h)],
             [k.cx + c*( 1  ) - s*( 0), k.cy + s*( 1 ) + c*( 0)],
             [k.cx + c*( 1/2) - s*( h), k.cy + s*( 1/2) + c*( h)]]
end

# Return the two end points of the specified edge (1-4)
function edge_points(d::Dart, i::Integer)
    if i<1 || i>4
        throw(DomainError(i,"out of range"))
    end

    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2
    pts = [[0,0], [-1/2,-h], [phi,0], [-1/2,h]]
    si = i
    ei = (i)%4 + 1
    sx = pts[si][1]
    sy = pts[si][2]
    ex = pts[ei][1]
    ey = pts[ei][2]
    c = cos(d.angle * pi / 180);
    s = sin(d.angle * pi / 180);
    [[d.cx + c*sx - s*sy, d.cy + s*sx + c*sy],
     [d.cx + c*ex - s*ey, d.cy + s*ex + c*ey]]
end

function edge_points(k::Kite, i::Integer)
    if i<1 || i>4
        throw(DomainError(i,"out of range"))
    end

    phi = (1+sqrt(5))/2
    h = sqrt(5+2*sqrt(5))/2
    pts = [[-phi,0], [ 1/2,-h], [1,0], [1/2,h]]
    si = i
    ei = (i)%4 + 1
    sx = pts[si][1]
    sy = pts[si][2]
    ex = pts[ei][1]
    ey = pts[ei][2]
    c = cos(k.angle * pi / 180);
    s = sin(k.angle * pi / 180);
    [[k.cx + c*sx - s*sy, k.cy + s*sx + c*sy],
     [k.cx + c*ex - s*ey, k.cy + s*ex + c*ey]]
end

# Return the center point of the specified edge
function edge_center(d::Dart, i::Integer)
    pts = edge_points(d,i);
    [(pts[1][1]+pts[2][1])/2, (pts[1][2]+pts[2][2])/2]
end

function edge_center(k::Kite, i::Integer)
    pts = edge_points(k,i);
    [(pts[1][1]+pts[2][1])/2, (pts[1][2]+pts[2][2])/2]
end

# Return the angle of the specified edge
function edge_angle(d::Dart, i::Integer)
    if i<1 || i>4
        throw(DomainError(i,"out of range"))
    end

    if i==1
        (252 + d.angle) % 360
    elseif i==2
        ( 36 + d.angle) % 360
    elseif i==3
        (144 + d.angle) % 360
    elseif i==4
        (288 + d.angle) % 360
    end
end

function edge_angle(k::Kite, i::Integer)
    if i<1 || i>4
        throw(DomainError(i,"out of range"))
    end

    if i==1
        (324 + k.angle) % 360
    elseif i==2
        ( 72 + k.angle) % 360
    elseif i==3
        (108 + k.angle) % 360
    elseif i==4
        (216 + k.angle) % 360
    end

end

end
