using Penrose
using Test

# Helper functions
# Returns length of an edge between 2 pts
edgelen_fcn(p) = sqrt((p[2][1]-p[1][1])*(p[2][1]-p[1][1])+(p[2][2]-p[1][2])*(p[2][2]-p[1][2]))
# Returns angle (in degrees) of an edge between 2 pts
angle_fcn(p) = (360 + atan(p[2][2]-p[1][2], p[2][1]-p[1][1]) * 180 / pi) % 360
# Returns the mid-point of an edge between 2 pts
midpt_fcn(p) = [(p[2][1]+p[1][1])/2, (p[2][2]+p[1][2])/2]
# Returns the distance between 2 pts
dist_fcn(p1,p2) = sqrt((p2[1]-p1[1])*(p2[1]-p1[1]) + (p2[2]-p1[2])*(p2[2]-p1[2]))

@testset "Dart angle" begin

    # Angles outside [0-360] should get fixed in ctor
    @testset "angle range" begin
        @test Dart(0,0,-40).angle == 320
        @test Dart(0,0,400).angle ==  40
    end

    @testset "angle internal" begin
        internal_angles = [36, 72, 36, 216]
        d = Dart(0,0,0)
        @test (edge_angle(d,1) + (540 - internal_angles[1]))%360 == edge_angle(d,2)
        @test (edge_angle(d,2) + (540 - internal_angles[2]))%360 == edge_angle(d,3)
        @test (edge_angle(d,3) + (540 - internal_angles[3]))%360 == edge_angle(d,4)
        @test (edge_angle(d,4) + (540 - internal_angles[4]))%360 == edge_angle(d,1)
    end

    @testset "angle 0" begin
        d0 = Dart(0,0,0)
        @test edge_angle(d0, 1) == 252
        @test edge_angle(d0, 2) ==  36
        @test edge_angle(d0, 3) == 144
        @test edge_angle(d0, 4) == 288
    end

    @testset "angle +90" begin
        d90 = Dart(0,0,90)
        @test edge_angle(d90, 1) == 342
        @test edge_angle(d90, 2) == 126
        @test edge_angle(d90, 3) == 234
        @test edge_angle(d90, 4) ==  18
    end

    # -270 should be the same as +90
    @testset "angle -270" begin
        m270 = Dart(0,0,-270)
        @test edge_angle(m270, 1) == 342
        @test edge_angle(m270, 2) == 126
        @test edge_angle(m270, 3) == 234
        @test edge_angle(m270, 4) ==  18
    end

    @testset "angle +180" begin
        d180 = Dart(0,0,180)
        @test edge_angle(d180, 1) ==  72
        @test edge_angle(d180, 2) == 216
        @test edge_angle(d180, 3) == 324
        @test edge_angle(d180, 4) == 108
    end

    # -180 should be the same as +180
    @testset "angle -180" begin
        m180 = Dart(0,0,-180)
        @test edge_angle(m180, 1) ==  72
        @test edge_angle(m180, 2) == 216
        @test edge_angle(m180, 3) == 324
        @test edge_angle(m180, 4) == 108
    end

end

@testset "Kite angle" begin

    @testset "angle internal" begin
        internal_angles = [72, 144, 72, 72]
        k = Kite(0,0,0)
        @test (edge_angle(k,1) + (540 - internal_angles[1]))%360 == edge_angle(k,2)
        @test (edge_angle(k,2) + (540 - internal_angles[2]))%360 == edge_angle(k,3)
        @test (edge_angle(k,3) + (540 - internal_angles[3]))%360 == edge_angle(k,4)
        @test (edge_angle(k,4) + (540 - internal_angles[4]))%360 == edge_angle(k,1)
    end

    @testset "angle 0" begin
        k0 = Kite(0,0,0)
        @test edge_angle(k0, 1) == 324
        @test edge_angle(k0, 2) ==  72
        @test edge_angle(k0, 3) == 108
        @test edge_angle(k0, 4) == 216
    end

    @testset "angle 90" begin
        k90 = Kite(0,0,90)
        @test edge_angle(k90, 1) ==  54
        @test edge_angle(k90, 2) == 162
        @test edge_angle(k90, 3) == 198
        @test edge_angle(k90, 4) == 306
    end

    @testset "angle -270" begin
        m0 = Kite(0,0,-270)
        @test edge_angle(m0, 1) ==  54
        @test edge_angle(m0, 2) == 162
        @test edge_angle(m0, 3) == 198
        @test edge_angle(m0, 4) == 306
    end

    @testset "angle 180" begin
        k180 = Kite(0,0,180)
        @test edge_angle(k180, 1) == 144
        @test edge_angle(k180, 2) == 252
        @test edge_angle(k180, 3) == 288
        @test edge_angle(k180, 4) ==  36
    end

    @testset "angle -180" begin
        m180 = Kite(0,0,-180)
        @test edge_angle(m180, 1) == 144
        @test edge_angle(m180, 2) == 252
        @test edge_angle(m180, 3) == 288
        @test edge_angle(m180, 4) ==  36
    end

end

@testset "Dart edge slopes" begin
    d = Dart(0,0,0)

    @test angle_fcn(edge_points(d,1)) == edge_angle(d,1)
    @test angle_fcn(edge_points(d,2)) == edge_angle(d,2)
    @test angle_fcn(edge_points(d,3)) == edge_angle(d,3)
    @test angle_fcn(edge_points(d,4)) == edge_angle(d,4)
end

@testset "Kite edge slopes" begin
    k = Kite(0,0,0)

    @test angle_fcn(edge_points(k,1)) == edge_angle(k,1)
    @test angle_fcn(edge_points(k,2)) == edge_angle(k,2)
    @test angle_fcn(edge_points(k,3)) == edge_angle(k,3)
    @test angle_fcn(edge_points(k,4)) == edge_angle(k,4)
end

@testset "Dart edge lengths" begin
    d = Dart(0,0,0)

    l1 = (1+sqrt(5))/2
    l2 = 1 + l1

    @test edgelen_fcn(edge_points(d,1)) == l1
    @test edgelen_fcn(edge_points(d,2)) == l2
    @test edgelen_fcn(edge_points(d,3)) == l2
    @test edgelen_fcn(edge_points(d,4)) == l1
end

@testset "Kite edge lengths" begin
    k = Kite(0,0,0)

    l1 = (1+sqrt(5))/2
    l2 = 1 + l1

    @test edgelen_fcn(edge_points(k,1)) == l2
    @test edgelen_fcn(edge_points(k,2)) == l1
    @test edgelen_fcn(edge_points(k,3)) == l1
    @test edgelen_fcn(edge_points(k,4)) == l2
end

@testset "Dart edge center" begin
    d = Dart(0,0,0)

    @test dist_fcn(midpt_fcn(edge_points(d,1)), edge_center(d,1)) == 0
    @test dist_fcn(midpt_fcn(edge_points(d,2)), edge_center(d,2)) == 0
    @test dist_fcn(midpt_fcn(edge_points(d,3)), edge_center(d,3)) == 0
    @test dist_fcn(midpt_fcn(edge_points(d,4)), edge_center(d,4)) == 0
end

@testset "Kite edge center" begin
    k = Kite(0,0,0)

    @test dist_fcn(midpt_fcn(edge_points(k,1)), edge_center(k,1)) == 0
    @test dist_fcn(midpt_fcn(edge_points(k,2)), edge_center(k,2)) == 0
    @test dist_fcn(midpt_fcn(edge_points(k,3)), edge_center(k,3)) == 0
    @test dist_fcn(midpt_fcn(edge_points(k,4)), edge_center(k,4)) == 0
end

@testset "Dart geometry" begin
    d = Dart(0,0,0)

    pts = geometry(d)
    @test size(pts) == (4,)
    @test dist_fcn(pts[1], edge_points(d,1)[1]) < 5e-8
    @test dist_fcn(pts[2], edge_points(d,1)[2]) < 5e-8
    @test dist_fcn(pts[2], edge_points(d,2)[1]) < 5e-8
    @test dist_fcn(pts[3], edge_points(d,2)[2]) < 5e-8
    @test dist_fcn(pts[3], edge_points(d,3)[1]) < 5e-8
    @test dist_fcn(pts[4], edge_points(d,3)[2]) < 5e-8
    @test dist_fcn(pts[4], edge_points(d,4)[1]) < 5e-8
    @test dist_fcn(pts[1], edge_points(d,4)[2]) < 5e-8
end

@testset "Kite geometry" begin
    k = Kite(0,0,0)

    pts = geometry(k)
    @test size(pts) == (4,)
    @test dist_fcn(pts[1], edge_points(k,1)[1]) < 5e-8
    @test dist_fcn(pts[2], edge_points(k,1)[2]) < 5e-8
    @test dist_fcn(pts[2], edge_points(k,2)[1]) < 5e-8
    @test dist_fcn(pts[3], edge_points(k,2)[2]) < 5e-8
    @test dist_fcn(pts[3], edge_points(k,3)[1]) < 5e-8
    @test dist_fcn(pts[4], edge_points(k,3)[2]) < 5e-8
    @test dist_fcn(pts[4], edge_points(k,4)[1]) < 5e-8
    @test dist_fcn(pts[1], edge_points(k,4)[2]) < 5e-8
end
