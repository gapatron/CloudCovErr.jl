module tst_cov
    using Test
    using cloudCovErr

    @testset "DECam" begin
        ref = "./test/data/decapsi/c4d_170119_085651_ood_r_v1.I.fits.fz"
        @test ref == cloudCovErr.inject_rename("./test/data/decaps/c4d_170119_085651_ood_r_v1.fits.fz")

        ref_im, d_im = cloudCovErr.read_decam("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/decaps/c4d_","170119_085651","r","v1","S6";corrects7=true)
        @test d_im[1,1] == 1
        @test abs(ref_im[1]-416.4855651855) < 1e-7

        out = cloudCovErr.read_crowdsource("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/","170119_085651","r","v1","S6")
        @test length(out) == 9
        wcol = out[end-1]
        w = out[end]

        out = cloudCovErr.load_psfmodel_cs("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/","170119_085651","r","v1","S6")
        @test size(out(1,1,11)) == (11,11)

        if isfile("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/cer/c4d_170119_085651_ooi_r_v1.cat.cer.fits")
            rm("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/cer/c4d_170119_085651_ooi_r_v1.cat.cer.fits")
        end
        save_fxn(wcol,w,"/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/","170119_085651","r","v1","S6")
        f = FITS("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/cer/c4d_170119_085651_ooi_r_v1.cat.cer.fits")
        @test length(read(f["S6_CAT"],"x")) == 14572
        close(f)
        if isfile("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/cer/c4d_170119_085651_ooi_r_v1.cat.cer.fits")
            rm("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/cer/c4d_170119_085651_ooi_r_v1.cat.cer.fits")
        end

        f = FITS("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/cat/c4d_170119_085651_ooi_r_v1.cat.fits")
        @test cloudCovErr.get_catnames(f) == ["S6","S7"]

        # run one real example end to end
        # @test_nowarn proc_all("/home/runner/work/cloudCovErr.jl/cloudCovErr.jl/test/data/decaps/c4d_","170119_085651","r","v1","test/data/",resume=true,corrects7=true,thr=20,outthr=20000,Np=33,widx=129,tilex=8)
    end
end
